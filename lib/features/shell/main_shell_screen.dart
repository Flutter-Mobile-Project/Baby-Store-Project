import 'package:baby_store_app/features/home/widgets/homeSidebar.dart';
import 'package:baby_store_app/features/shop/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../home/home_screen.dart';
import '../favorites/favorites_screen.dart';
import '../settings/settings_screen.dart';
import '../nearby/nearby_screen.dart';
import '../booking/booking_screen.dart';
import '../chat/chat_screen.dart';
import '../map/map_screen.dart';
import '../promotions/promotions_screen.dart';
import '../cart/cart_screen.dart';
import 'widgets/app_header.dart';
import 'widgets/app_footer.dart';

// Tab index constants — easy to reference anywhere
const int tabHome = 0;
const int tabShop = 1;
const int tabFavorites = 2;
const int tabProfile = 3;
const int tabCart = 4;
const int tabNearby = 5;
const int tabBooking = 6;
const int tabChat = 7;
const int tabMap = 8;
const int tabPromotions = 9;

class MainShellScreen extends ConsumerStatefulWidget {
  const MainShellScreen({super.key});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  int _selectedIndex = tabHome;

  List<Map<String, String>> _favorites = [];
  List<Map<String, dynamic>> _cartItems = [];

  void _toggleFavorite(Map<String, String> item) {
    setState(() {
      final exists = _favorites.any((e) => e['title'] == item['title']);
      if (exists) {
        _favorites.removeWhere((e) => e['title'] == item['title']);
      } else {
        _favorites.add(item);
      }
    });
  }

  // ── All pages in one IndexedStack ──────────────────────────────
  List<Widget> get _pages => [
    HomeBody(favorites: _favorites, onToggleFavorite: _toggleFavorite), // 0
    // const Center(child: Text('Shop — coming soon')), // 1
    const ShopScreen(),

    FavoritesScreen(
      // 2
      favoriteItems: _favorites,
      onFavoritesUpdated: () => setState(() {}),
    ),
    const SettingsScreen(), // 3
    // ✅ Add onNavigate here
    CartScreen(
      cartItems: _cartItems,
      favorites: _favorites,
      isTab: true, // ✅ shell tab mode

      onNavigate: (tabIndex) => setState(() => _selectedIndex = tabIndex),
    ), //4
    const NearbyScreen(), // 5
    const BookingScreen(), // 6
    const ChatScreen(), // 7
    const MapScreen(), // 8
    const PromotionsScreen(), // 9
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        drawer: HomeDrawer(
          // Pass a callback so drawer can switch tabs
          onNavigate: (int tabIndex) {
            setState(() => _selectedIndex = tabIndex);
          },
        ),
        appBar: AppHeader(
          cartItemCount: _cartItems.length,
          onCartPressed: () => setState(() => _selectedIndex = tabCart),
          onSearchPressed: () {},
          onMenuPressed: () => Scaffold.of(context).openDrawer(),
        ),
        body: IndexedStack(index: _selectedIndex, children: _pages),
        bottomNavigationBar: AppFooter(
          selectedIndex: _selectedIndex,
          favoritesCount: _favorites.length,
          onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        ),
      ),
    );
  }
}
