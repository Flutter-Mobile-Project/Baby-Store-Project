import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class AppFooter extends StatelessWidget {
  final int selectedIndex;
  final int favoritesCount;
  final Function(int) onDestinationSelected;

  const AppFooter({
    super.key,
    required this.selectedIndex,
    required this.favoritesCount,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
          // Clamp to 4 visible tabs
          selectedIndex: selectedIndex > 3 ? 0 : selectedIndex,
          onDestinationSelected: onDestinationSelected,
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
                label: Text('$favoritesCount'),
                isLabelVisible: favoritesCount > 0,
                child: const Icon(Icons.favorite),
              ),
              icon: Badge(
                label: Text('$favoritesCount'),
                isLabelVisible: favoritesCount > 0,
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
    );
  }
}
