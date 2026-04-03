import 'package:go_router/go_router.dart';

import '../pages/device_detail_page.dart';
import '../pages/device_list_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../providers/auth_provider.dart';

class AppRouter {
  final AuthProvider authProvider;

  AppRouter(this.authProvider);

  late final GoRouter router = GoRouter(
    refreshListenable: authProvider,
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuth = authProvider.isAuthenticated;
      final isAuthRoute =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isAuth && !isAuthRoute) return '/login';
      if (isAuth && isAuthRoute) return '/devices';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) =>
            LoginPage(onSwitchToRegister: () => context.go('/register')),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) =>
            RegisterPage(onSwitchToLogin: () => context.go('/login')),
      ),
      GoRoute(
        path: '/devices',
        builder: (context, state) =>
            DeviceListPage(onDeviceTap: (id) => context.go('/devices/$id')),
      ),
      GoRoute(
        path: '/devices/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DeviceDetailPage(
            deviceId: id,
            onBack: () => context.go('/devices'),
          );
        },
      ),
    ],
  );
}
