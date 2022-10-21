import 'package:flutter/material.dart';
import 'package:location_sharing_app/navigation/navigator.dart';
import 'package:location_sharing_app/navigation/routes.dart';

void main() {
  runApp(const MyApp());
}

class InitialStartupRoute {
  final String path;
  dynamic args;

  InitialStartupRoute(this.path, {this.args});
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    InitialStartupRoute initRoute = InitialStartupRoute(Routes.LOGIN);

    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'We Track Cars',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      onGenerateRoute: MainNavigator.generateRoute,
      onGenerateInitialRoutes: (String initialRouteName) {
        return [
          MainNavigator.generateRoute(
              RouteSettings(name: initRoute.path, arguments: initRoute.args))
        ];
      },
      navigatorObservers: [routeObserver],
    );
  }
}
