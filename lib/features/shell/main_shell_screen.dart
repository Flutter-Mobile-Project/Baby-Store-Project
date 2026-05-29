import 'package:baby_store_app/features/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../home/home_screen.dart';
import '../favorites/favorites_screen.dart';
import '../settings/settings_screen.dart';
import '../home/widgets/homeSidebar.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  const MainShellScreen({super.key});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  int _selectedIndex = 0;
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

  List<Widget> get _pages => [
    HomeBody(favorites: _favorites, onToggleFavorite: _toggleFavorite),
    const Center(child: Text('Shop — coming soon')),
    FavoritesScreen(
      favoriteItems: _favorites,
      onFavoritesUpdated: () => setState(() {}),
    ),
    const SettingsScreen(),
    // 🎯 FIX 2: Pass down a callback to change index back to 0 (Home) safely
    CartScreen(
      cartItems: _cartItems,
      onBack: () => setState(() => _selectedIndex = 0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // ✅ Prevents any accidental pop from emptying the navigator stack
      canPop: false,
      child: Scaffold(
        drawer: const HomeDrawer(),
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
                // 🎯 FIX 1: Look at _cartItems.length, not favorites!
                label: Text('${_cartItems.length}'),
                isLabelVisible: _cartItems.isNotEmpty,
                backgroundColor: Colors.redAccent,
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.textPrimary,
                ),
              ),
              onPressed: () {
                // Switches the IndexedStack layer to display your CartScreen (index 4)
                setState(() => _selectedIndex = 4);
              },
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

                // ✅ Favorites with live badge — remove const
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
