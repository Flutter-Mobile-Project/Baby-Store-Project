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

  // In _MainShellScreenState — add method:
  void _moveToCart(List<Map<String, dynamic>> items) {
    setState(() {
      for (final item in items) {
        final existing = _cartItems.indexWhere(
          (e) => e['title'] == item['title'],
        );
        if (existing != -1) {
          _cartItems[existing]['qty']++;
        } else {
          _cartItems.add(Map.from(item));
        }
      }
      _selectedIndex = tabCart; // ✅ switch to cart tab
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

  List<Widget> get _pages => [
<<<<<<< HEAD
  HomeBody(
    favorites: _favorites,
    onToggleFavorite: _toggleFavorite,
    onAddToCart: _moveToCart,
  ), // tabHome (0)
  ShopScreen(
    favoriteItems: _favorites, 
    onToggleFavorite: _toggleFavorite,
    onAddToCart: _moveToCart,
  ), // tabShop (1)
  FavoritesScreen(
    favoriteItems: _favorites,
    onFavoritesUpdated: () => setState(() {}),
    onMoveToCart: _moveToCart,
  ), // tabFavorites (2)
  const SettingsScreen(), // tabProfile (3)
  CartScreen(
    cartItems: _cartItems,
    favorites: _favorites,
    couponCode: _selectedCoupon,
    isTab: true,
    onNavigate: (tabIndex) => setState(() => _selectedIndex = tabIndex),
  ), // tabCart (4)
  const NearbyScreen(), // tabNearby (5)
  const BookingScreen(), // tabBooking (6)
  const ChatScreen(), // tabChat (7)
  const MapScreen(), // tabMap (8)
  PromotionsScreen(onCouponApplied: _applyCoupon), // tabPromotions (9)
];
=======
    HomeBody(
      // 0
      favorites: _favorites,
      onToggleFavorite: _toggleFavorite,
    ),
    const ShopScreen(), // 1
    FavoritesScreen(
      // 2
      favoriteItems: _favorites,
      onFavoritesUpdated: () => setState(() {}),
      onMoveToCart: _moveToCart,
    ),
    SettingsScreen(onLogout: _onLogout), // 3
    CartScreen(
      // 4
      cartItems: _cartItems,
      favorites: _favorites,
      couponCode: _selectedCoupon,
      isTab: true,
      onNavigate: (i) => setState(() => _selectedIndex = i),
    ),
    NearbyScreen(
      // 5
      onNavigate: (i) => setState(() => _selectedIndex = i),
    ),
    BookingScreen(
      // 6 ✅ restored
      // onNavigate: (i) => setState(() => _selectedIndex = i),
    ),
    const ChatScreen(), // 7
    const MapScreen(), // 8 ✅ now correct
    PromotionsScreen(onCouponApplied: _applyCoupon), // 9
  ];
>>>>>>> 0c5f4946e956ec11c297a5046c1e0604f12753a3

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
        // ── All tab content ────────────────────────────────────
        child: IndexedStack(index: _selectedIndex, children: _pages),
      ),
    );
  }
}
