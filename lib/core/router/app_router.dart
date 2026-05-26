import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/journal/presentation/screens/home_screen.dart';
import '../../features/journal/presentation/screens/editor_screen.dart';
import '../../features/journal/presentation/screens/favorites_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

class AuthGuard {
  static String? redirect(Ref ref, GoRouterState state) {
    final authState = ref.read(authProvider);
    final isAuthenticated = authState.user != null;
    final isAuthRoute = state.matchedLocation == '/login' ||
        state.matchedLocation == '/register' ||
        state.matchedLocation == '/forgot-password';

    if (!isAuthenticated && !isAuthRoute) return '/login';
    if (isAuthenticated && isAuthRoute) return '/';
    return null;
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) => AuthGuard.redirect(ref, state),
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'journal/:id',
            name: 'journal',
            builder: (context, state) => EditorScreen(
              journalId: state.pathParameters['id'],
            ),
          ),
          GoRoute(
            path: 'new',
            name: 'new-journal',
            builder: (context, state) => const EditorScreen(),
          ),
          GoRoute(
            path: 'favorites',
            name: 'favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});