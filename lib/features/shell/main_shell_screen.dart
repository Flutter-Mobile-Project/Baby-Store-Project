import 'package:baby_store_app/features/shell/app_shell.dart';
import 'package:baby_store_app/features/shop/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home/home_screen.dart';
import '../favorites/favorites_screen.dart';
import '../settings/settings_screen.dart';
import '../nearby/nearby_screen.dart';
import '../booking/booking_screen.dart';
import '../chat/chat_screen.dart';
import '../map/map_screen.dart';
import '../promotions/promotions_screen.dart';
import '../cart/cart_screen.dart';

// Tab index constants
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
  String? _selectedCoupon;

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

  void _applyCoupon(String code) {
    setState(() {
      _selectedCoupon = code;
      _selectedIndex = tabCart;
    });
  }

  void _moveToCart(List<Map<String, dynamic>> items) {
    setState(() {
      for (final item in items) {
        final existing = _cartItems.indexWhere((e) => e['title'] == item['title']);
        if (existing != -1) {
          _cartItems[existing]['qty'] += item['qty'] ?? 1;
        } else {
          _cartItems.add(Map.from(item));
        }
      }
      _selectedIndex = tabCart;
    });
  }

  void _onLogout() {
    setState(() {
      _selectedIndex = tabHome;
      _cartItems = [];
      _favorites = [];
      _selectedCoupon = null;
    });
  }

  // ✅ This is the ONLY _pages getter you need
  List<Widget> get _pages => [
        HomeBody(
          favorites: _favorites,
          onToggleFavorite: _toggleFavorite,
          onAddToCart: _moveToCart,
        ), // 0
        ShopScreen(
          favoriteItems: _favorites,
          onToggleFavorite: _toggleFavorite,
          onAddToCart: _moveToCart,
        ), // 1
        FavoritesScreen(
          favoriteItems: _favorites,
          onFavoritesUpdated: () => setState(() {}),
          onMoveToCart: _moveToCart,
        ), // 2
        SettingsScreen(onLogout: _onLogout), // 3
        CartScreen(
          cartItems: _cartItems,
          favorites: _favorites,
          couponCode: _selectedCoupon,
          isTab: true,
          onNavigate: (tabIndex) => setState(() => _selectedIndex = tabIndex),
        ), // 4
        NearbyScreen(
          onNavigate: (i) => setState(() => _selectedIndex = i),
        ), // 5
        const BookingScreen(), // 6
        const ChatScreen(), // 7
        const MapScreen(), // 8
        PromotionsScreen(onCouponApplied: _applyCoupon), // 9
      ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AppShell(
        selectedIndex: _selectedIndex,
        cartItemCount: _cartItems.length,
        favoritesCount: _favorites.length,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        onCartPressed: () => setState(() => _selectedIndex = tabCart),
        onSearchPressed: () {},
        onNavigate: (i) => setState(() => _selectedIndex = i),
        child: IndexedStack(index: _selectedIndex, children: _pages),
      ),
    );
  }
}