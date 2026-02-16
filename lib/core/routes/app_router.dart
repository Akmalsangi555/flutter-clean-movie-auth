
import 'route_views.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: _handleRedirect,
    refreshListenable: _AuthStateNotifier(),
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const SplashPage()),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: SignupPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: HomePage()),
      ),
      // Movie Details Route
      GoRoute(
        path: '/movie-details/:id',
        name: 'movie-details',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          final movie = state.extra as Results?;

          return CustomTransitionPage(
            key: state.pageKey,
            child: MovieDetailsScreen(movie: movie, movieId: id),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          );
        },
      ),
    ],
  );

  static Future<String?> _handleRedirect(
      BuildContext context,
      GoRouterState state,
      ) async {
    final authController = AuthController.to;

    // Wait for auth check to complete
    if (authController.isCheckingAuth.value) {
      return null;
    }

    final isAuthenticated = authController.isAuthenticated.value;
    final location = state.matchedLocation;

    // If authenticated
    if (isAuthenticated) {
      // Allow accessing login page (browser back will trigger auto-logout)
      if (location == '/login') {
        return null;
      }

      // If we are on signup or splash, go to home
      if (location == '/signup' || location == '/splash') {
        return '/home';
      }

      // Otherwise stay where we are
      return null;
    }

    // If not authenticated
    if (!isAuthenticated) {
      // Protect authenticated routes
      if (location == '/home' || location.startsWith('/movie-details')) {
        return '/login';
      }
      // If we are on splash, go to login
      if (location == '/splash') {
        return '/login';
      }
      return null;
    }

    return null;
  }

  // static Future<String?> _handleRedirect(
  //   BuildContext context,
  //   GoRouterState state,
  // ) async {
  //   final authController = AuthController.to;
  //
  //   // Wait for auth check to complete
  //   if (authController.isCheckingAuth.value) {
  //     // Stay where we are while checking auth to preserve the URL
  //     return null;
  //   }
  //
  //   final isAuthenticated = authController.isAuthenticated.value;
  //   final location = state.matchedLocation;
  //
  //   // If authenticated
  //   if (isAuthenticated) {
  //     // If we are on auth-related pages, go to home
  //     if (location == '/login' ||
  //         location == '/signup' ||
  //         location == '/splash') {
  //       return '/home';
  //     }
  //     // Otherwise stay where we are (e.g., /movie-details)
  //     return null;
  //   }
  //
  //   // If not authenticated
  //   if (!isAuthenticated) {
  //     // Protect authenticated routes
  //     if (location == '/home' || location == '/movie-details') {
  //       return '/login';
  //     }
  //     // If we are on splash, go to login
  //     if (location == '/splash') {
  //       return '/login';
  //     }
  //     return null;
  //   }
  //
  //   return null;
  // }
}

// Listenable for auth state changes
class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier() {
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(Duration.zero);
    final authController = AuthController.to;

    void listener() {
      notifyListeners();
    }

    authController.isAuthenticated.listen((_) => listener());
    authController.isCheckingAuth.listen((_) => listener());
  }

  @override
  void dispose() {
    super.dispose();
  }
}
