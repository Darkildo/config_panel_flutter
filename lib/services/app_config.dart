import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application configuration for the gRPC-Web backend connection.
///
/// Resolution order (first non-empty wins):
///   1. `.env` file (runtime, loaded as Flutter asset)
///   2. `--dart-define` (compile-time)
///   3. Built-in defaults (localhost:8080, no TLS)
class AppConfig {
  final String host;
  final int port;
  final bool useTls;

  const AppConfig({
    required this.host,
    required this.port,
    this.useTls = false,
  });

  /// Load `.env` asset. Call once before [fromEnvironment].
  ///
  /// Silently continues if the file is missing (falls back to --dart-define).
  static Future<void> loadDotEnv() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // .env not bundled — that's fine, --dart-define or defaults will be used
    }
  }

  /// Build config with priority: .env > --dart-define > defaults.
  factory AppConfig.fromEnvironment() {
    const dartDefineHost = String.fromEnvironment(
      'GRPC_HOST',
      defaultValue: '',
    );
    const dartDefinePort = int.fromEnvironment('GRPC_PORT', defaultValue: 0);
    const dartDefineTls = bool.fromEnvironment('GRPC_TLS', defaultValue: false);

    final envHost = dotenv.maybeGet('GRPC_HOST');
    final envPort = dotenv.maybeGet('GRPC_PORT');
    final envTls = dotenv.maybeGet('GRPC_TLS');

    final host = _firstNonEmpty([envHost, dartDefineHost]) ?? 'localhost';
    final port = _firstInt([envPort, dartDefinePort]) ?? 8080;
    final useTls = _firstBool([envTls, dartDefineTls]) ?? false;

    return AppConfig(host: host, port: port, useTls: useTls);
  }

  String get authority => '$host:$port';

  @override
  String toString() => 'AppConfig(${useTls ? "https" : "http"}://$host:$port)';

  // ── Resolution helpers ──

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
