import 'package:flutter/material.dart';
import '../presentation/screens/screens.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SignupScreen.routeName:
        return SignupScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case HomeScreen.routeName:
        return HomeScreen.route();
      default:
        return _buildErrorRoute(settings: settings);
    }
  }
}

MaterialPageRoute _buildErrorRoute({required settings}) {
  return MaterialPageRoute(
    settings: settings,
    builder: (_) {
      return const Scaffold(
        body: Center(
          child: Text("Error: Something went wrong"),
        ),
      );
    },
  );
}
