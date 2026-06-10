import 'package:flutter/material.dart';
import '../features/shell/main_shell_screen.dart';
import '../features/shop/order_history_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const MainShellScreen());

      case '/order-history':
        return MaterialPageRoute(builder: (_) => const OrderHistoryScreen());

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
