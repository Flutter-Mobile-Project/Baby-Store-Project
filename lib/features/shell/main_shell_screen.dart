import 'package:baby_store_app/features/shell/app_shell.dart';
import 'package:baby_store_app/features/shop/shop_screen.dart';
import 'dart:async';

import 'package:baby_store_app/services/auth_service.dart';
import 'package:baby_store_app/services/favorites_service.dart';
import 'package:baby_store_app/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home/home_screen.dart';
import '../favorites/favorites_screen.dart';
import '../settings/settings_screen.dart';
import '../shop/order_history_screen.dart';
import '../nearby/nearby_screen.dart';
import '../booking/booking_screen.dart';
import '../chat/chat_screen.dart';
import '../map/map_screen.dart';
import '../promotions/promotions_screen.dart';
import '../cart/cart_screen.dart';
import '../cart/checkout_screen.dart';

// ── Tab index constants ────────────────────────────────────────────
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
const int tabCheckout = 10;
const int tabOrderHistory = 11;
// ✅ OrderHistoryScreen is now managed by the shell instead of a standalone pushed route

class MainShellScreen extends ConsumerStatefulWidget {
  final int initialIndex;

  const MainShellScreen({super.key, this.initialIndex = tabHome});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  late int _selectedIndex;
  String? _selectedCoupon;
  double _discountAmount = 0;
  StreamSubscription<List<Map<String, String>>>? _favoritesSubscription;

  List<Map<String, String>> _favorites = [];
  List<Map<String, dynamic>> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _syncUser();
  }

  @override
  void dispose() {
    _favoritesSubscription?.cancel();
    super.dispose();
  }

  Future<void> _syncUser() async {
    final uid = AuthService.currentUid;
    if (uid == null) return;

    final profile = await AuthService.getUserProfile(uid);
    if (profile != null && mounted) {
      ref.read(userProvider.notifier).state = profile;
    }

    _startFavoriteSync(uid);
  }

  void _startFavoriteSync(String uid) {
    _favoritesSubscription?.cancel();
    _favoritesSubscription = FavoritesService.favoritesStream(uid).listen(
      (favorites) {
        if (!mounted) return;
        setState(() {
          _favorites = favorites;
        });
      },
      onError: (error) {
        debugPrint('Favorites listener error: $error');
      },
    );
  }

  void _toggleFavorite(Map<String, String> item) {
    final uid = AuthService.currentUid;
    final title = item['title'] ?? '';
    final exists = _favorites.any((e) => e['title'] == title);

    setState(() {
      if (exists) {
        _favorites.removeWhere((e) => e['title'] == title);
      } else {
        _favorites.add(item);
      }
    });

    if (uid != null && title.isNotEmpty) {
      _syncFavoriteToBackend(uid, item, exists);
    }
  }

  Future<void> _syncFavoriteToBackend(
    String uid,
    Map<String, String> item,
    bool exists,
  ) async {
    try {
      if (exists) {
        await FavoritesService.removeFavorite(uid, item['title']!);
      } else {
        await FavoritesService.addFavorite(uid, item);
      }
    } catch (e) {
      debugPrint('Error syncing favorite: $e');
    }
  }

  void _applyCoupon(String code) {
    const coupons = {
      'WELCOME20': {'type': 'percentage', 'value': 20},
      'WHEELS50': {'type': 'fixed', 'value': 50},
      'B3G1FREE': {'type': 'percentage', 'value': 25},
    };

    final coupon = coupons[code];
    double discount = 0;

    if (coupon != null) {
      final subtotal = _cartItems.fold<double>(
        0,
        (sum, item) => sum + ((item['price'] ?? 0) * (item['qty'] ?? 1)),
      );
      // ✅ Fixed — cast as num not double
      final value = (coupon['value'] as num).toDouble();
      discount = coupon['type'] == 'percentage'
          ? subtotal * value / 100
          : value;
    }

    setState(() {
      _selectedCoupon = code;
      _discountAmount = discount;
      _selectedIndex = tabCart;
    });
  }

  void _moveToCart(List<Map<String, dynamic>> items) {
    setState(() {
      for (final item in items) {
        final existing = _cartItems.indexWhere(
          (e) => e['title'] == item['title'],
        );
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
    _favoritesSubscription?.cancel();
    _favoritesSubscription = null;

    setState(() {
      _selectedIndex = tabHome;
      _cartItems = [];
      _favorites = [];
      _selectedCoupon = null;
      _discountAmount = 0;
    });
  }

  void _onOrderComplete() {
    _syncUser();
    setState(() {
      _cartItems = [];
      _selectedCoupon = null;
      _discountAmount = 0;
      _selectedIndex = tabHome;
    });
  }

  List<Widget> get _pages => [
    HomeBody(
      // 0
      favorites: _favorites,
      onToggleFavorite: _toggleFavorite,
      onAddToCart: _moveToCart,
    ),
    ShopScreen(
      // 1
      favoriteItems: _favorites,
      onToggleFavorite: _toggleFavorite,
      onAddToCart: _moveToCart,
    ),
    FavoritesScreen(
      // 2
      favoriteItems: _favorites,
      onFavoritesUpdated: () => setState(() {}),
      onMoveToCart: _moveToCart,
      onRemoveFavorite: _toggleFavorite,
    ),
    SettingsScreen(
      onLogout: _onLogout,
      onOrderHistoryTap: () => setState(() => _selectedIndex = tabOrderHistory),
    ), // 3
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
      // 6 ✅ onNavigate added
      onNavigate: (i) => setState(() => _selectedIndex = i),
    ),
    const ChatScreen(), // 7
    const MapScreen(), // 8
    PromotionsScreen(onCouponApplied: _applyCoupon), // 9
    CheckoutScreen(
      // 10
      cartItems: _cartItems,
      total: _cartItems.fold(
        0,
        (sum, item) => sum + ((item['price'] ?? 0) * (item['qty'] ?? 1)),
      ),
      discountAmount: _discountAmount,
      isTab: true,
      onOrderComplete: _onOrderComplete,
    ),
    const OrderHistoryScreen(),
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
