import 'package:flutter/material.dart';
import '../features/shell/main_shell_screen.dart';
import '../features/nearby/nearby_screen.dart';
import '../features/booking/booking_screen.dart';
import '../features/chat/chat_screen.dart';
import '../features/map/map_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/promotions/promotions_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        // ✅ Must be MainShellScreen, NOT HomeScreen or HomeBody
        return MaterialPageRoute(builder: (_) => const MainShellScreen());

      case '/nearby':
        return MaterialPageRoute(builder: (_) => const NearbyScreen());

      case '/booking':
        return MaterialPageRoute(builder: (_) => const BookingScreen());

      case '/chat':
        return MaterialPageRoute(builder: (_) => const ChatScreen());

      case '/map':
        return MaterialPageRoute(builder: (_) => const MapScreen());

      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case '/promotions':
        return MaterialPageRoute(builder: (_) => const PromotionsScreen());

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
