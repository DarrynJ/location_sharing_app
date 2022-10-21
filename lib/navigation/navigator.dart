import 'package:flutter/material.dart';
import 'package:location_sharing_app/navigation/routes.dart';
import 'package:location_sharing_app/screens/login_screen.dart';
import 'package:location_sharing_app/screens/map_screen.dart';

class MainNavigator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) {
        switch (settings.name) {
          case Routes.HOME:
          case Routes.MAP:
          case Routes.LOGIN:
            return const LoginScreen();
          default:
            return const MapScreen();
        }
      },
    );
  }
}
