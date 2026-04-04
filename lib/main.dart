import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/config_provider.dart';
import 'providers/device_provider.dart';
import 'providers/user_provider.dart';
import 'router/app_router.dart';
import 'services/api_service.dart';
import 'services/app_config.dart';
import 'services/grpc_api_service.dart';
import 'services/token_storage.dart';
import 'theme/responsive.dart';
import 'theme/retro_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  await AppConfig.loadDotEnv();
  final config = AppConfig.fromEnvironment();
  debugPrint('Connecting to gRPC-Web server: $config');

  final apiService = GrpcApiService(config: config);
  final tokenStorage = TokenStorage();

  final authProvider = AuthProvider(
    apiService,
    tokenStorage: tokenStorage,
    onTokenChanged: apiService.setToken,
  );

  await authProvider.tryRestoreSession();

  runApp(ConfigPanelApp(apiService: apiService, authProvider: authProvider));
}

class ConfigPanelApp extends StatefulWidget {
  final ApiService apiService;
  final AuthProvider authProvider;

  const ConfigPanelApp({
    super.key,
    required this.apiService,
    required this.authProvider,
  });

  @override
  State<ConfigPanelApp> createState() => _ConfigPanelAppState();
}

class _ConfigPanelAppState extends State<ConfigPanelApp> {
  late final DeviceProvider _deviceProvider;
  late final ConfigProvider _configProvider;
  late final UserProvider _userProvider;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _deviceProvider = DeviceProvider(widget.apiService);
    _configProvider = ConfigProvider(widget.apiService);
    _userProvider = UserProvider(widget.apiService);
    _appRouter = AppRouter(widget.authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.authProvider),
        ChangeNotifierProvider.value(value: _deviceProvider),
        ChangeNotifierProvider.value(value: _configProvider),
        ChangeNotifierProvider.value(value: _userProvider),
        Provider<ApiService>.value(value: widget.apiService),
      ],
      child: MaterialApp.router(
        title: 'CTRL PANEL',
        debugShowCheckedModeBanner: false,
        theme: RetroTheme.darkTheme,
        routerConfig: _appRouter.router,
        builder: (context, child) {
          return MinSizeContainer(child: child ?? const SizedBox.shrink());
        },
      ),
    );
  }
}
