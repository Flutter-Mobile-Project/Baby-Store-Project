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
        appBar: AppBar(
          backgroundColor: AppColors.cream,
          elevation: 0,
          centerTitle: false,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: AppColors.textPrimary),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: const Text(
            'TinyTots',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.textPrimary),
              onPressed: () {},
            ),
            IconButton(
              icon: Badge(
                label: Text('${_cartItems.length}'),
                isLabelVisible: _cartItems.isNotEmpty,
                backgroundColor: Colors.redAccent,
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.textPrimary,
                ),
              ),
              // ✅ Cart icon switches to cart tab
              onPressed: () => setState(() => _selectedIndex = tabCart),
            ),
            const SizedBox(width: 8),
          ],
        ),

        body: IndexedStack(index: _selectedIndex, children: _pages),

        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: AppColors.babyBlue,
              labelTextStyle: WidgetStateProperty.all(
                const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            child: NavigationBar(
              backgroundColor: AppColors.beige,
              height: 80,
              // ✅ Clamp to 4 visible tabs — hidden tabs (4-9) don't affect indicator
              selectedIndex: _selectedIndex > 3 ? 0 : _selectedIndex,
              onDestinationSelected: (i) => setState(() => _selectedIndex = i),
              destinations: [
                const NavigationDestination(
                  selectedIcon: Icon(Icons.home),
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                const NavigationDestination(
                  selectedIcon: Icon(Icons.storefront),
                  icon: Icon(Icons.storefront_outlined),
                  label: 'Shop',
                ),
                NavigationDestination(
                  selectedIcon: Badge(
                    label: Text('${_favorites.length}'),
                    isLabelVisible: _favorites.isNotEmpty,
                    child: const Icon(Icons.favorite),
                  ),
                  icon: Badge(
                    label: Text('${_favorites.length}'),
                    isLabelVisible: _favorites.isNotEmpty,
                    child: const Icon(Icons.favorite_border),
                  ),
                  label: 'Favorites',
                ),
                const NavigationDestination(
                  selectedIcon: Icon(Icons.person),
                  icon: Icon(Icons.person_outline),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
