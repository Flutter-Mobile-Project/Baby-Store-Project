import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Map<String, String>> favoriteItems;
  // Optional: A callback to notify the Home layout to update its heart icons instantly
  final VoidCallback? onFavoritesUpdated;

  const FavoritesScreen({
    super.key,
    required this.favoriteItems,
    this.onFavoritesUpdated,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    // Directly use widget.favoriteItems to keep state perfectly synchronized
    final favorites = widget.favoriteItems;

    return Scaffold(
      backgroundColor: AppColors.cream,

      // ================= APP BAR =================
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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.favorite, color: Colors.redAccent),
          ),
        ],
      ),

      // ================= BODY =================
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'No favorite items yet ❤️',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Your Favorites',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${favorites.length} ${favorites.length == 1 ? "item" : "items"} waiting for their forever home',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),

                // Using .map() directly over the shared live reference list
                ...favorites.map((item) => _buildFavoriteCard(item)).toList(),
              ],
            ),

      // ================= BOTTOM NAVIGATION =================
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

              // Smoothly return back to the main screen layout context
              if (index == 0) {
                Navigator.pop(context);
              }
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
                selectedIcon: Icon(Icons.favorite, color: Colors.redAccent),
                icon: Icon(
                  Icons.favorite_border,
                  color: AppColors.textSecondary,
                ),
                label: 'Favorites',
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

  // ================= FAVORITE CARD =================
  Widget _buildFavoriteCard(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  item['image']!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      // Remove item straight out of the shared array pointer reference
                      widget.favoriteItems.remove(item);
                    });
                    // Call update hook to refresh home display state heart shapes
                    if (widget.onFavoritesUpdated != null) {
                      widget.onFavoritesUpdated!();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item['title']!,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                item['price']!,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item['description'] ?? item['category'] ?? 'Product',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B6B7A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 18,
              ),
              label: const Text(
                'Move to Cart',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
