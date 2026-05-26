import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'widgets/home_widgets.dart';
import 'widgets/category_grid.dart';
import 'widgets/new_arrivals.dart';
import 'widgets/homeSidebar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // ✅ FIX: real mutable favorites list
  List<Map<String, String>> favorites = [];

  // ✅ toggle favorite function
  void toggleFavorite(Map<String, String> item) {
    setState(() {
      final exists = favorites.any((e) => e['title'] == item['title']);

      if (exists) {
        favorites.removeWhere((e) => e['title'] == item['title']);
      } else {
        favorites.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        centerTitle: false,
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
              label: Text('${favorites.length}'), // ✅ dynamic badge
              backgroundColor: Colors.redAccent,
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.textPrimary,
              ),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 20),
            const TopBanner(),
            const SizedBox(height: 24),
            const AgeFilter(),
            const SizedBox(height: 24),
            const FlashSaleStrip(),
            const SizedBox(height: 24),
            const CategoryGrid(),
            const SizedBox(height: 24),

            // ✅ FIXED NewArrivals
            NewArrivals(
              favoriteItems: favorites,
              onToggleFavorite: toggleFavorite, // ✅ ADD THIS
            ),
          ],
        ),
      ),

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
            selectedIndex: _selectedIndex,

            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },

            destinations: const [
              NavigationDestination(
                selectedIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.storefront),
                icon: Icon(Icons.storefront_outlined),
                label: 'Shop',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.card_giftcard),
                icon: Icon(Icons.card_giftcard),
                label: 'Registry',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.person),
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
