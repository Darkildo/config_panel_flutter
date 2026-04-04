import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  final String host;
  final int port;
  final bool useTls;

  const AppConfig({
    required this.host,
    required this.port,
    this.useTls = false,
  });

  static Future<void> loadDotEnv() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {}
  }

  factory AppConfig.fromEnvironment() {
    const dartDefineHost = String.fromEnvironment(
      'GRPC_HOST',
      defaultValue: '',
    );
    const dartDefinePort = int.fromEnvironment('GRPC_PORT', defaultValue: 0);
    const dartDefineTls = bool.fromEnvironment('GRPC_TLS', defaultValue: false);

    final envHost = _dotenvGet('GRPC_HOST');
    final envPort = _dotenvGet('GRPC_PORT');
    final envTls = _dotenvGet('GRPC_TLS');

    final host = _firstNonEmpty([envHost, dartDefineHost]) ?? 'localhost';
    final port = _firstInt([envPort, dartDefinePort]) ?? 8080;
    final useTls = _firstBool([envTls, dartDefineTls]) ?? false;

    return AppConfig(host: host, port: port, useTls: useTls);
  }

  String get authority => '$host:$port';

  @override
  String toString() => 'AppConfig(${useTls ? "https" : "http"}://$host:$port)';

  static String? _dotenvGet(String key) {
    try {
      return dotenv.maybeGet(key);
    } catch (_) {
      return null;
    }
  }

  static String? _firstNonEmpty(List<String?> values) {
    for (final v in values) {
      if (v != null && v.isNotEmpty) return v;
    }
    return null;
  }

  static int? _firstInt(List<Object?> values) {
    for (final v in values) {
      if (v is int && v != 0) return v;
      if (v is String && v.isNotEmpty) {
        final parsed = int.tryParse(v);
        if (parsed != null && parsed != 0) return parsed;
      }
    }
    return null;
  }

  static bool? _firstBool(List<Object?> values) {
    for (final v in values) {
      if (v is bool && v) return v;
      if (v is String && v.isNotEmpty) {
        if (v.toLowerCase() == 'true') return true;
        if (v.toLowerCase() == 'false') return false;
      }
    }
    return null;
  }
}
