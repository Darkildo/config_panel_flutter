import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc_or_grpcweb.dart';

import '../generated/proto/v1/auth.pbgrpc.dart' as pb_auth;
import '../generated/proto/v1/config.pbgrpc.dart' as pb_config;
import '../generated/proto/v1/device.pbgrpc.dart' as pb_device;
import '../models/auth.dart';
import '../models/config.dart';
import '../models/device.dart';
import 'api_service.dart';
import 'app_config.dart';

/// gRPC-Web implementation of [ApiService].
///
/// Connects to the Go backend via gRPC-Web (HTTP/1.1 compatible,
/// works in browsers and on mobile).
class GrpcApiService implements ApiService {
  final AppConfig config;

  late final GrpcOrGrpcWebClientChannel _channel;
  late final pb_auth.AuthServiceClient _authClient;
  late final pb_device.DeviceServiceClient _deviceClient;
  late final pb_config.ConfigServiceClient _configClient;

  /// Auth token received after login/register, used for subsequent calls.
  String? _token;

  GrpcApiService({required this.config}) {
    _channel = GrpcOrGrpcWebClientChannel.toSingleEndpoint(
      host: config.host,
      port: config.port,
      transportSecure: config.useTls,
    );

    _authClient = pb_auth.AuthServiceClient(_channel);
    _deviceClient = pb_device.DeviceServiceClient(_channel);
    _configClient = pb_config.ConfigServiceClient(_channel);
  }

  /// Build [CallOptions] with the auth token if available.
  CallOptions? get _callOptions {
    if (_token == null) return null;
    return CallOptions(metadata: {'authorization': 'Bearer $_token'});
  }

  void dispose() {
    _channel.shutdown();
  }

  // ── Auth ──

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _authClient.register(
        pb_auth.RegisterRequest(
          login: request.login,
          password: request.password,
        ),
      );
      _token = response.token;
      return AuthResponse(token: response.token);
    } on GrpcError catch (e) {
      throw Exception(e.message ?? 'Registration failed');
    }
  }

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _authClient.login(
        pb_auth.LoginRequest(login: request.login, password: request.password),
      );
      _token = response.token;
      return AuthResponse(token: response.token);
    } on GrpcError catch (e) {
      throw Exception(e.message ?? 'Login failed');
    }
  }

  // ── Devices ──

  @override
  Future<Device> createDevice(CreateDeviceRequest request) async {
    try {
      final response = await _deviceClient.createDevice(
        pb_device.CreateDeviceRequest(
          hostname: request.hostname,
          ip: request.ip,
          location: request.location,
          isActive: request.isActive,
        ),
        options: _callOptions,
      );
      return _mapDevice(response);
    } on GrpcError catch (e) {
      throw Exception(e.message ?? 'Failed to create device');
    }
  }

  @override
  Future<List<Device>> listDevices(ListDevicesRequest request) async {
    try {
      final pbRequest = pb_device.ListDevicesRequest(
        hostnameSearch: request.hostnameSearch,
      );
      if (request.isActive != null) {
        pbRequest.isActive = request.isActive!;
      }

      final response = await _deviceClient.listDevices(
        pbRequest,
        options: _callOptions,
      );
      return response.devices.map(_mapDevice).toList();
    } on GrpcError catch (e) {
      throw Exception(e.message ?? 'Failed to list devices');
    }
  }

  // ── Configs ──

  @override
  Future<DeviceConfig> createConfig(CreateConfigRequest request) async {
    try {
      final response = await _configClient.createConfig(
        pb_config.CreateConfigRequest(
          deviceId: Int64(request.deviceId),
          version: request.version,
          content: request.content,
        ),
        options: _callOptions,
      );
      return _mapConfig(response);
    } on GrpcError catch (e) {
      throw Exception(e.message ?? 'Failed to create config');
    }
  }

  @override
  Future<ListConfigsResponse> listConfigs(ListConfigsRequest request) async {
    try {
      final response = await _configClient.listConfigs(
        pb_config.ListConfigsRequest(
          deviceId: Int64(request.deviceId),
          page: request.page,
          pageSize: request.pageSize,
        ),
        options: _callOptions,
      );
      return ListConfigsResponse(
        configs: response.configs.map(_mapConfig).toList(),
        total: response.total,
        page: response.page,
        pageSize: response.pageSize,
      );
    } on GrpcError catch (e) {
      throw Exception(e.message ?? 'Failed to list configs');
    }
  }

  @override
  Future<ApplyConfigResponse> applyConfig(int configId) async {
    try {
      final response = await _configClient.applyConfig(
        pb_config.ApplyConfigRequest(id: Int64(configId)),
        options: _callOptions,
      );
      return ApplyConfigResponse(
        success: response.success,
        appliedAt: response.appliedAt.toDateTime(),
      );
    } on GrpcError catch (e) {
      throw Exception(e.message ?? 'Failed to apply config');
    }
  }

  // ── Mappers: protobuf -> domain models ──

  Device _mapDevice(pb_device.DeviceResponse pb) {
    return Device(
      id: pb.id.toInt(),
      hostname: pb.hostname,
      ip: pb.ip,
      location: pb.location,
      isActive: pb.isActive,
      createdAt: pb.createdAt.toDateTime(),
    );
  }

  DeviceConfig _mapConfig(pb_config.ConfigResponse pb) {
    return DeviceConfig(
      id: pb.id.toInt(),
      deviceId: pb.deviceId.toInt(),
      version: pb.version,
      content: pb.content,
      createdAt: pb.createdAt.toDateTime(),
      appliedAt: pb.hasAppliedAt() ? pb.appliedAt.toDateTime() : null,
    );
  }
}
