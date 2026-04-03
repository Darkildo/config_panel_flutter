import '../models/auth.dart';
import '../models/config.dart';
import '../models/device.dart';

/// Abstract API service matching proto service definitions.
/// Implementations can be gRPC-based or mock for development.
abstract class ApiService {
  // ── AuthService ──
  Future<AuthResponse> register(RegisterRequest request);
  Future<AuthResponse> login(LoginRequest request);

  // ── DeviceService ──
  Future<Device> createDevice(CreateDeviceRequest request);
  Future<List<Device>> listDevices(ListDevicesRequest request);

  // ── ConfigService ──
  Future<DeviceConfig> createConfig(CreateConfigRequest request);
  Future<ListConfigsResponse> listConfigs(ListConfigsRequest request);
  Future<ApplyConfigResponse> applyConfig(int configId);
}
