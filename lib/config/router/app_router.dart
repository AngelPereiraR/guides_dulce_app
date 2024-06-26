import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart' as main;
import '../../presentation/providers/providers.dart';
import '../../presentation/screens/screens.dart';
import '../config.dart';

// This is super important - otherwise, we would throw away the whole widget tree when the provider is updated.
final navigatorKey = GlobalKey<NavigatorState>();
// We need to have access to the previous location of the router. Otherwise, we would start from '/' on rebuild.
GoRouter? _previousRouter;

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = main.container.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation:
        _previousRouter?.routerDelegate.currentConfiguration.fullPath,
    navigatorKey: navigatorKey,
    refreshListenable: goRouterNotifier,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/',
        name: HomeScreen.name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/create-category',
        name: CreateCategoryScreen.name,
        builder: (context, state) => const CreateCategoryScreen(),
      ),
      GoRoute(
        path: '/edit-category/:id',
        name: EditCategoryScreen.name,
        builder: (context, state) {
          final categoryId = int.parse(state.pathParameters['id'] ?? '0');
          return EditCategoryScreen(id: categoryId);
        },
      ),
      GoRoute(
        path: '/login',
        name: LoginScreen.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/category/:id',
        name: CategoryScreen.name,
        builder: (context, state) {
          final categoryId = int.parse(state.pathParameters['id'] ?? '0');
          return CategoryScreen(categoryId: categoryId);
        },
      ),
      GoRoute(
        path: '/create-guide/:categoryId',
        name: CreateGuideScreen.name,
        builder: (context, state) {
          final categoryId =
              int.parse(state.pathParameters['categoryId'] ?? '0');
          return CreateGuideScreen(categoryId: categoryId);
        },
      ),
      GoRoute(
        path: '/edit-guide/:categoryId/:id',
        name: EditGuideScreen.name,
        builder: (context, state) {
          final categoryId =
              int.parse(state.pathParameters['categoryId'] ?? '0');
          final guideId = int.parse(state.pathParameters['id'] ?? '0');
          return EditGuideScreen(categoryId: categoryId, id: guideId);
        },
      ),
      GoRoute(
        path: '/guide/:categoryId/:id',
        name: GuideScreen.name,
        builder: (context, state) {
          final categoryId =
              int.parse(state.pathParameters['categoryId'] ?? '0');
          final guideId = int.parse(state.pathParameters['id'] ?? '0');
          return GuideScreen(categoryId: categoryId, guideId: guideId);
        },
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
          return '/';
        }
      }

      return null;
    },
  );
});
