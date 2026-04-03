import 'package:flutter_test/flutter_test.dart';
import 'package:config_panel_flutter/models/device.dart';
import 'package:config_panel_flutter/models/config.dart';
import 'package:config_panel_flutter/models/auth.dart';
import 'package:config_panel_flutter/services/mock_api_service.dart';

void main() {
  group('Models', () {
    test('Device.fromJson works correctly', () {
      final json = {
        'id': 1,
        'hostname': 'test-host',
        'ip': '10.0.0.1',
        'location': 'DC-1',
        'is_active': true,
        'created_at': '2024-01-01T00:00:00.000',
      };
      final device = Device.fromJson(json);
      expect(device.id, 1);
      expect(device.hostname, 'test-host');
      expect(device.isActive, true);
    });

    test('DeviceConfig.isApplied returns correct value', () {
      final config = DeviceConfig(
        id: 1,
        deviceId: 1,
        version: 'v1.0',
        content: 'test',
        createdAt: DateTime.now(),
      );
      expect(config.isApplied, false);

      final applied = config.copyWith(appliedAt: DateTime.now());
      expect(applied.isApplied, true);
    });

    test('AuthResponse.fromJson works correctly', () {
      final json = {'token': 'test_token_123'};
      final auth = AuthResponse.fromJson(json);
      expect(auth.token, 'test_token_123');
    });
  });

  group('MockApiService', () {
    late MockApiService api;

    setUp(() {
      api = MockApiService();
    });

    test('login returns token', () async {
      final response = await api.login(
        const LoginRequest(login: 'admin', password: '1234'),
      );
      expect(response.token, isNotEmpty);
    });

    test('register returns token', () async {
      final response = await api.register(
        const RegisterRequest(login: 'newuser', password: '1234'),
      );
      expect(response.token, isNotEmpty);
    });

    test('listDevices returns devices', () async {
      final devices = await api.listDevices(const ListDevicesRequest());
      expect(devices, isNotEmpty);
    });

    test('listDevices filters by active', () async {
      final active = await api.listDevices(
        const ListDevicesRequest(isActive: true),
      );
      expect(active.every((d) => d.isActive), true);
    });

    test('listDevices filters by hostname search', () async {
      final results = await api.listDevices(
        const ListDevicesRequest(hostnameSearch: 'web'),
      );
      expect(
        results.every((d) => d.hostname.toLowerCase().contains('web')),
        true,
      );
    });

    test('listConfigs returns configs for device', () async {
      final response = await api.listConfigs(
        const ListConfigsRequest(deviceId: 1),
      );
      expect(response.configs, isNotEmpty);
      expect(response.configs.every((c) => c.deviceId == 1), true);
    });

    test('createConfig adds new config', () async {
      final config = await api.createConfig(
        const CreateConfigRequest(
          deviceId: 1,
          version: 'v2.0.0',
          content: 'new config',
        ),
      );
      expect(config.version, 'v2.0.0');
      expect(config.deviceId, 1);
      expect(config.isApplied, false);
    });

    test('applyConfig marks config as applied', () async {
      // Config id=3 is not applied in mock data
      final response = await api.applyConfig(3);
      expect(response.success, true);
      expect(response.appliedAt, isNotNull);
    });
  });
}
