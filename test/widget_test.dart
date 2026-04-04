import 'package:flutter_test/flutter_test.dart';
import 'package:config_panel_flutter/models/device.dart';
import 'package:config_panel_flutter/models/config.dart';
import 'package:config_panel_flutter/models/auth.dart';
import 'package:config_panel_flutter/services/app_config.dart';

void main() {
  group('Models', () {
    test('Device fields', () {
      final device = Device(
        id: 1,
        hostname: 'test-host',
        ip: '10.0.0.1',
        location: 'DC-1',
        isActive: true,
        createdAt: DateTime(2024, 1, 1),
      );
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

    test('DeviceConfig.copyWith preserves fields', () {
      final config = DeviceConfig(
        id: 10,
        deviceId: 5,
        version: 'v2.0',
        content: 'data',
        createdAt: DateTime(2024, 1, 1),
      );
      final now = DateTime.now();
      final applied = config.copyWith(appliedAt: now);

      expect(applied.id, 10);
      expect(applied.deviceId, 5);
      expect(applied.version, 'v2.0');
      expect(applied.content, 'data');
      expect(applied.appliedAt, now);
    });

    test('AuthResponse token', () {
      const auth = AuthResponse(token: 'test_token_123');
      expect(auth.token, 'test_token_123');
    });

    test('User fields', () {
      final user = User(id: 1, login: 'admin', createdAt: DateTime(2024, 1, 1));
      expect(user.id, 1);
      expect(user.login, 'admin');
    });

    test('ListDevicesRequest defaults', () {
      const req = ListDevicesRequest();
      expect(req.isActive, isNull);
      expect(req.hostnameSearch, '');
    });

    test('ListConfigsRequest defaults', () {
      const req = ListConfigsRequest(deviceId: 1);
      expect(req.page, 1);
      expect(req.pageSize, 20);
    });

    test('UpdateDeviceRequest optional fields', () {
      const req = UpdateDeviceRequest(id: 1, hostname: 'new-host');
      expect(req.id, 1);
      expect(req.hostname, 'new-host');
      expect(req.ip, isNull);
    });
  });

  group('AppConfig', () {
    test('defaults to localhost:8080', () {
      final config = AppConfig.fromEnvironment();
      expect(config.host, 'localhost');
      expect(config.port, 8080);
      expect(config.useTls, false);
    });

    test('authority string format', () {
      const config = AppConfig(host: '10.0.0.1', port: 9090);
      expect(config.authority, '10.0.0.1:9090');
    });

    test('toString includes protocol', () {
      const config = AppConfig(host: 'api.test', port: 443, useTls: true);
      expect(config.toString(), contains('https'));
      expect(config.toString(), contains('api.test'));
    });
  });
}
