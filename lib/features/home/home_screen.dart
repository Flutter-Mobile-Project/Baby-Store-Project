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
  //  This variable remembers which tab is currently active
  int _selectedIndex = 0;

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
              label: const Text('2'),
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
          children: const [
            SizedBox(height: 20),
            TopBanner(),
            SizedBox(height: 24),
            AgeFilter(),
            SizedBox(height: 24),
            FlashSaleStrip(),
            SizedBox(height: 24),
            CategoryGrid(),
            SizedBox(height: 24),
            NewArrivals(),
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
            elevation: 0,

            selectedIndex: _selectedIndex,

            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },

            destinations: const [
              NavigationDestination(
                selectedIcon: Icon(Icons.home, color: AppColors.textPrimary),
                icon: Icon(Icons.home_outlined, color: AppColors.textSecondary),
                label: 'Home',
              ),
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.storefront,
                  color: AppColors.textPrimary,
                ),
                icon: Icon(
                  Icons.storefront_outlined,
                  color: AppColors.textSecondary,
                ),
                label: 'Shop',
              ),
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.card_giftcard,
                  color: AppColors.textPrimary,
                ),
                icon: Icon(Icons.card_giftcard, color: AppColors.textSecondary),
                label: 'Registry',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.person, color: AppColors.textPrimary),
                icon: Icon(
                  Icons.person_outline,
                  color: AppColors.textSecondary,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
