import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/config_provider.dart';
import 'providers/device_provider.dart';
import 'router/app_router.dart';
import 'services/api_service.dart';
import 'services/mock_api_service.dart';
import 'theme/retro_theme.dart';

void main() {
  final apiService = MockApiService();

  runApp(ConfigPanelApp(apiService: apiService));
}

class ConfigPanelApp extends StatefulWidget {
  final ApiService apiService;

  const ConfigPanelApp({super.key, required this.apiService});

  @override
  State<ConfigPanelApp> createState() => _ConfigPanelAppState();
}

class _ConfigPanelAppState extends State<ConfigPanelApp> {
  late final AuthProvider _authProvider;
  late final DeviceProvider _deviceProvider;
  late final ConfigProvider _configProvider;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider(widget.apiService);
    _deviceProvider = DeviceProvider(widget.apiService);
    _configProvider = ConfigProvider(widget.apiService);
    _appRouter = AppRouter(_authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider.value(value: _deviceProvider),
        ChangeNotifierProvider.value(value: _configProvider),
        Provider<ApiService>.value(value: widget.apiService),
      ],
      child: MaterialApp.router(
        title: 'CTRL PANEL // Device Config Manager',
        debugShowCheckedModeBanner: false,
        theme: RetroTheme.darkTheme,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
