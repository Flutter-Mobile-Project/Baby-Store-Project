import 'package:flutter/material.dart';

// Home
import '../features/home/home_screen.dart';

// Member 3 screens
import '../features/nearby/nearby_screen.dart';
import '../features/booking/booking_screen.dart';
import '../features/chat/chat_screen.dart';
import '../features/map/map_screen.dart';

// Optional (create later if needed)
import '../features/promotions/promotions_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ✅ Home
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      // ✅ Nearby Stores
      case '/nearby':
        return MaterialPageRoute(builder: (_) => const NearbyScreen());

      // ✅ Booking
      case '/booking':
        return MaterialPageRoute(builder: (_) => const BookingScreen());

      // ✅ Chat
      case '/chat':
        return MaterialPageRoute(builder: (_) => const ChatScreen());

      // ✅ Map
      case '/map':
        return MaterialPageRoute(builder: (_) => const MapScreen());

      // ✅ Promotions (temporary placeholder)
      // case '/promotions':
      //   return MaterialPageRoute(
      //     builder: (_) => const PromotionsScreen(),
      //   );

      // ❌ Unknown route
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
