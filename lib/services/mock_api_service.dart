import 'dart:math';

import '../models/auth.dart';
import '../models/config.dart';
import '../models/device.dart';
import 'api_service.dart';

class MockApiService implements ApiService {
  final _random = Random();
  int _nextDeviceId = 100;
  int _nextConfigId = 1000;
  int _nextUserId = 10;

  final List<User> _users = [
    User(id: 1, login: 'admin', createdAt: DateTime(2024, 1, 1)),
    User(id: 2, login: 'operator', createdAt: DateTime(2024, 3, 15)),
  ];

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
  ];

  final Map<int, List<DeviceConfig>> _configs = {
    1: [
      DeviceConfig(
        id: 1,
        deviceId: 1,
        version: 'v1.0.0',
        content: '# nginx.conf\nworker_processes auto;',
        createdAt: DateTime(2024, 1, 16),
        appliedAt: DateTime(2024, 1, 16, 14, 30),
      ),
      DeviceConfig(
        id: 2,
        deviceId: 1,
        version: 'v1.1.0',
        content: '# nginx.conf\nworker_processes 4;',
        createdAt: DateTime(2024, 3, 1),
        appliedAt: DateTime(2024, 3, 2, 10, 0),
      ),
      DeviceConfig(
        id: 3,
        deviceId: 1,
        version: 'v1.2.0-rc1',
        content: '# nginx.conf\nworker_processes 8;',
        createdAt: DateTime(2024, 6, 10),
      ),
    ],
    2: [
      DeviceConfig(
        id: 4,
        deviceId: 2,
        version: 'v3.2.1',
        content: '[mysqld]\ninnodb_buffer_pool_size=4G',
        createdAt: DateTime(2024, 2, 5),
        appliedAt: DateTime(2024, 2, 5, 8, 0),
      ),
    ],
  };

  Future<void> _simulateLatency() async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(400)));
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    await _simulateLatency();
    if (request.login.isEmpty || request.password.isEmpty)
      throw Exception('Login and password are required');
    if (request.password.length < 4)
      throw Exception('Password must be at least 4 characters');
    return AuthResponse(
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    await _simulateLatency();
    if (request.login.isEmpty || request.password.isEmpty)
      throw Exception('Login and password are required');
    return AuthResponse(
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<User> getUser(int id) async {
    await _simulateLatency();
    return _users.firstWhere(
      (u) => u.id == id,
      orElse: () => throw Exception('User #$id not found'),
    );
  }

  @override
  Future<List<User>> listUsers(ListUsersRequest request) async {
    await _simulateLatency();
    var result = List<User>.from(_users);
    if (request.loginSearch.isNotEmpty) {
      final q = request.loginSearch.toLowerCase();
      result = result.where((u) => u.login.toLowerCase().contains(q)).toList();
    }
    return result;
  }

  @override
  Future<User> updateUser(UpdateUserRequest request) async {
    await _simulateLatency();
    final idx = _users.indexWhere((u) => u.id == request.id);
    if (idx == -1) throw Exception('User #${request.id} not found');
    final old = _users[idx];
    final updated = User(
      id: old.id,
      login: request.login ?? old.login,
      createdAt: old.createdAt,
    );
    _users[idx] = updated;
    return updated;
  }

  @override
  Future<void> deleteUser(int id) async {
    await _simulateLatency();
    final idx = _users.indexWhere((u) => u.id == id);
    if (idx == -1) throw Exception('User #$id not found');
    _users.removeAt(idx);
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
  Future<Device> getDevice(int id) async {
    await _simulateLatency();
    return _devices.firstWhere(
      (d) => d.id == id,
      orElse: () => throw Exception('Device #$id not found'),
    );
  }

  @override
  Future<List<Device>> listDevices(ListDevicesRequest request) async {
    await _simulateLatency();
    var result = List<Device>.from(_devices);
    if (request.isActive != null) {
      result = result.where((d) => d.isActive == request.isActive).toList();
    }
    if (request.hostnameSearch.isNotEmpty) {
      final q = request.hostnameSearch.toLowerCase();
      result = result
          .where((d) => d.hostname.toLowerCase().contains(q))
          .toList();
    }
    return result;
  }

  @override
  Future<Device> updateDevice(UpdateDeviceRequest request) async {
    await _simulateLatency();
    final idx = _devices.indexWhere((d) => d.id == request.id);
    if (idx == -1) throw Exception('Device #${request.id} not found');
    final old = _devices[idx];
    final updated = Device(
      id: old.id,
      hostname: request.hostname ?? old.hostname,
      ip: request.ip ?? old.ip,
      location: request.location ?? old.location,
      isActive: request.isActive ?? old.isActive,
      createdAt: old.createdAt,
    );
    _devices[idx] = updated;
    return updated;
  }

  @override
  Future<void> deleteDevice(int id) async {
    await _simulateLatency();
    final idx = _devices.indexWhere((d) => d.id == id);
    if (idx == -1) throw Exception('Device #$id not found');
    _devices.removeAt(idx);
    _configs.remove(id);
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
  Future<DeviceConfig> getConfig(int id) async {
    await _simulateLatency();
    for (final list in _configs.values) {
      for (final c in list) {
        if (c.id == id) return c;
      }
    }
    throw Exception('Config #$id not found');
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
  Future<DeviceConfig> updateConfig(UpdateConfigRequest request) async {
    await _simulateLatency();
    for (final entry in _configs.entries) {
      final idx = entry.value.indexWhere((c) => c.id == request.id);
      if (idx != -1) {
        final old = entry.value[idx];
        final updated = old.copyWith(
          version: request.version,
          content: request.content,
        );
        _configs[entry.key]![idx] = updated;
        return updated;
      }
    }
    throw Exception('Config #${request.id} not found');
  }

  @override
  Future<void> deleteConfig(int id) async {
    await _simulateLatency();
    for (final entry in _configs.entries) {
      final idx = entry.value.indexWhere((c) => c.id == id);
      if (idx != -1) {
        _configs[entry.key]!.removeAt(idx);
        return;
      }
    }
    throw Exception('Config #$id not found');
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
