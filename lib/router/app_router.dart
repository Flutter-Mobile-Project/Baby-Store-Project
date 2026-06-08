import 'package:flutter/material.dart';
import '../features/shell/main_shell_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const MainShellScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page not found', style: TextStyle(fontSize: 18)),
            ),
          ),
        );
    }
  }
}
