import 'package:baby_store_app/data/mock_repository.dart';
import 'package:baby_store_app/state/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/shell/main_shell_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider<BookingProvider>(
            // Instantiates the lifecycle provider scope context right when the shell loads
            create: (_) => BookingProvider(repository: MockRepository()),
            child: const MainShellScreen(),
          ),
        );

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
