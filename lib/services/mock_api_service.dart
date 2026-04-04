import 'dart:math';

import '../models/auth.dart';
import '../models/config.dart';
import '../models/device.dart';
import 'api_service.dart';

class MockApiService implements ApiService {
  final _random = Random();
  int _nextDeviceId = 100;
  int _nextConfigId = 1000;

  final List<Device> _devices = [
    Device(
      id: 1,
      hostname: 'srv-web-01.dc1.local',
      ip: '192.168.1.10',
      location: 'DC-1 Rack A3',
      isActive: true,
      createdAt: DateTime(2024, 1, 15),
    ),
    Device(
      id: 2,
      hostname: 'srv-db-master.dc1.local',
      ip: '192.168.1.20',
      location: 'DC-1 Rack B7',
      isActive: true,
      createdAt: DateTime(2024, 2, 3),
    ),
    Device(
      id: 3,
      hostname: 'srv-cache-01.dc2.local',
      ip: '10.0.2.15',
      location: 'DC-2 Rack C1',
      isActive: false,
      createdAt: DateTime(2024, 3, 20),
    ),
    Device(
      id: 4,
      hostname: 'srv-api-gateway.dc1.local',
      ip: '192.168.1.100',
      location: 'DC-1 Rack A1',
      isActive: true,
      createdAt: DateTime(2024, 4, 10),
    ),
    Device(
      id: 5,
      hostname: 'srv-monitoring.dc2.local',
      ip: '10.0.2.50',
      location: 'DC-2 Rack D4',
      isActive: true,
      createdAt: DateTime(2024, 5, 1),
    ),
    Device(
      id: 6,
      hostname: 'srv-backup-01.dc1.local',
      ip: '192.168.1.200',
      location: 'DC-1 Rack E2',
      isActive: false,
      createdAt: DateTime(2023, 12, 1),
    ),
    Device(
      id: 7,
      hostname: 'srv-mail.dc2.local',
      ip: '10.0.2.25',
      location: 'DC-2 Rack A5',
      isActive: true,
      createdAt: DateTime(2024, 6, 15),
    ),
    Device(
      id: 8,
      hostname: 'srv-proxy-02.dc1.local',
      ip: '192.168.1.55',
      location: 'DC-1 Rack F3',
      isActive: false,
      createdAt: DateTime(2024, 1, 28),
    ),
  ];

  final Map<int, List<DeviceConfig>> _configs = {
    1: [
      DeviceConfig(
        id: 1,
        deviceId: 1,
        version: 'v1.0.0',
        content:
            '# nginx.conf\nworker_processes auto;\nevents { worker_connections 1024; }',
        createdAt: DateTime(2024, 1, 16),
        appliedAt: DateTime(2024, 1, 16, 14, 30),
      ),
      DeviceConfig(
        id: 2,
        deviceId: 1,
        version: 'v1.1.0',
        content:
            '# nginx.conf\nworker_processes 4;\nevents { worker_connections 2048; }\nhttp { gzip on; }',
        createdAt: DateTime(2024, 3, 1),
        appliedAt: DateTime(2024, 3, 2, 10, 0),
      ),
      DeviceConfig(
        id: 3,
        deviceId: 1,
        version: 'v1.2.0-rc1',
        content:
            '# nginx.conf\nworker_processes 8;\nevents { worker_connections 4096; }\nhttp { gzip on; ssl_protocols TLSv1.3; }',
        createdAt: DateTime(2024, 6, 10),
        appliedAt: null,
      ),
    ],
    2: [
      DeviceConfig(
        id: 4,
        deviceId: 2,
        version: 'v3.2.1',
        content: '[mysqld]\ninnodb_buffer_pool_size=4G\nmax_connections=500',
        createdAt: DateTime(2024, 2, 5),
        appliedAt: DateTime(2024, 2, 5, 8, 0),
      ),
    ],
    4: [
      DeviceConfig(
        id: 5,
        deviceId: 4,
        version: 'v2.0.0',
        content:
            'upstream backend {\n  server 192.168.1.10:8080;\n  server 192.168.1.11:8080;\n}',
        createdAt: DateTime(2024, 4, 12),
        appliedAt: DateTime(2024, 4, 12, 16, 0),
      ),
    ],
  };

  Future<void> _simulateLatency() async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(400)));
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    await _simulateLatency();
    if (request.login.isEmpty || request.password.isEmpty) {
      throw Exception('Login and password are required');
    }
    if (request.password.length < 4) {
      throw Exception('Password must be at least 4 characters');
    }
    final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    return AuthResponse(token: token);
  }

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    await _simulateLatency();
    if (request.login.isEmpty || request.password.isEmpty) {
      throw Exception('Login and password are required');
    }
    final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    return AuthResponse(token: token);
  }

  @override
  Future<Device> createDevice(CreateDeviceRequest request) async {
    await _simulateLatency();
    final device = Device(
      id: _nextDeviceId++,
      hostname: request.hostname,
      ip: request.ip,
      location: request.location,
      isActive: request.isActive,
      createdAt: DateTime.now(),
    );
    _devices.add(device);
    return device;
  }

  @override
  Future<List<Device>> listDevices(ListDevicesRequest request) async {
    await _simulateLatency();
    var result = List<Device>.from(_devices);

    if (request.isActive != null) {
      result = result.where((d) => d.isActive == request.isActive).toList();
    }

    if (request.hostnameSearch.isNotEmpty) {
      final query = request.hostnameSearch.toLowerCase();
      result = result
          .where((d) => d.hostname.toLowerCase().contains(query))
          .toList();
    }

    return result;
  }

  @override
  Future<DeviceConfig> createConfig(CreateConfigRequest request) async {
    await _simulateLatency();
    final config = DeviceConfig(
      id: _nextConfigId++,
      deviceId: request.deviceId,
      version: request.version,
      content: request.content,
      createdAt: DateTime.now(),
    );
    _configs.putIfAbsent(request.deviceId, () => []);
    _configs[request.deviceId]!.add(config);
    return config;
  }

  @override
  Future<ListConfigsResponse> listConfigs(ListConfigsRequest request) async {
    await _simulateLatency();
    final all = _configs[request.deviceId] ?? [];
    final total = all.length;
    final start = (request.page - 1) * request.pageSize;
    final end = (start + request.pageSize).clamp(0, total);
    final page = start < total ? all.sublist(start, end) : <DeviceConfig>[];

    return ListConfigsResponse(
      configs: page,
      total: total,
      page: request.page,
      pageSize: request.pageSize,
    );
  }

  @override
  Future<ApplyConfigResponse> applyConfig(int configId) async {
    await _simulateLatency();
    final appliedAt = DateTime.now();

    for (final entry in _configs.entries) {
      final idx = entry.value.indexWhere((c) => c.id == configId);
      if (idx != -1) {
        _configs[entry.key]![idx] = entry.value[idx].copyWith(
          appliedAt: appliedAt,
        );
        return ApplyConfigResponse(success: true, appliedAt: appliedAt);
      }
    }

    throw Exception('Config #$configId not found');
  }
}
