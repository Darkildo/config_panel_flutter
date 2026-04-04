/// Application configuration for the gRPC-Web backend connection.
///
/// Can be set via:
/// - Compile-time: `--dart-define=GRPC_HOST=...` / `--dart-define=GRPC_PORT=...`
/// - Defaults: localhost:8080
class AppConfig {
  final String host;
  final int port;
  final bool useTls;

  const AppConfig({
    required this.host,
    required this.port,
    this.useTls = false,
  });

  /// Build from `--dart-define` environment variables.
  ///
  /// Usage:
  ///   flutter run --dart-define=GRPC_HOST=192.168.1.50 --dart-define=GRPC_PORT=8080
  ///   flutter run --dart-define=GRPC_HOST=api.example.com --dart-define=GRPC_PORT=443 --dart-define=GRPC_TLS=true
  factory AppConfig.fromEnvironment() {
    const host = String.fromEnvironment('GRPC_HOST', defaultValue: 'localhost');
    const port = int.fromEnvironment('GRPC_PORT', defaultValue: 8080);
    const useTls = bool.fromEnvironment('GRPC_TLS', defaultValue: false);

    return AppConfig(host: host, port: port, useTls: useTls);
  }

  String get authority => '$host:$port';

  @override
  String toString() => 'AppConfig(${useTls ? "https" : "http"}://$host:$port)';
}
