import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/providers/providers.dart';
import '../../presentation/screens/screens.dart';
import '../config.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: goRouterNotifier,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),
      GoRoute(
        path: '/home',
        name: HomeScreen.name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: LoginScreen.name,
        builder: (context, state) => LoginScreen(),
      ),
    ],
    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login') return null;
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/splash') {
          return '/home';
        }
      }

      return null;
    },
  );
});
