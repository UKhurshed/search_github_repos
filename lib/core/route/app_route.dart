import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:search_github_repos/core/route/route_names.dart';
import 'package:search_github_repos/screens/splash/splash_screen.dart';
import 'package:search_github_repos/screens/home/home_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final _router = GoRouter(
      debugLogDiagnostics: true,
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/splash',
      routes: [
        GoRoute(
            path: '/splash',
            name: RouteNames.splash,
            builder: (context, state) => const SplashScreen()),
        GoRoute(
            path: '/home',
            name: RouteNames.home,
            builder: (context, state) => const HomeScreen()),
      ]);
}
