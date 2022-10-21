import 'package:flutter/material.dart';
import 'package:location_sharing_app/navigation/routes.dart';
import 'package:location_sharing_app/screens/login_screen.dart';
import 'package:location_sharing_app/screens/home_screen.dart';
import 'package:location_sharing_app/screens/map_screen.dart';

class MainNavigator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) {
        switch (settings.name) {
          case Routes.HOME:
            final args = settings.arguments as String;
            return HomeScreen(username: args);
          case Routes.MAP:
            final args = settings.arguments as String;
            return MapScreen(username: args);
          case Routes.LOGIN:
            return const LoginScreen();
          default:
            return const LoginScreen();
        }
      },
    );
  }
}
