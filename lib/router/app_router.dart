import 'package:flutter/material.dart';

// Member 3 screens
import '../features/map/map_screen.dart';
import '../features/nearby/nearby_screen.dart';
import '../features/booking/booking_screen.dart';
import '../features/chat/chat_screen.dart';
import '../features/reviews/reviews_screen.dart';
import '../features/home/home_placeholder.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePlaceholder());

      case '/map':
        return MaterialPageRoute(builder: (_) => const MapScreen());

      case '/nearby':
        return MaterialPageRoute(builder: (_) => const NearbyScreen());

      case '/booking':
        return MaterialPageRoute(builder: (_) => const BookingScreen());

      case '/chat':
        return MaterialPageRoute(builder: (_) => const ChatScreen());

      case '/reviews':
        return MaterialPageRoute(builder: (_) => const ReviewsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
