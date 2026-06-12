import 'package:flutter/material.dart';
import 'widgets/home_widgets.dart';
import 'widgets/category_grid.dart';
import 'widgets/new_arrivals.dart';

// HomeBody has no Scaffold, no drawer — just the ListView content
class HomeBody extends StatelessWidget {
  final List<Map<String, String>> favorites;
  final void Function(Map<String, String>) onToggleFavorite;
  final Function(List<Map<String, dynamic>>) onAddToCart;
  final Function(Map<String, dynamic>) onViewProduct;
  final Function(int) onNavigate;
  final Function(String) onCategoryTap;
  
  const HomeBody({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
    required this.onAddToCart,
    required this.onViewProduct,
    required this.onNavigate,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 20),
          // PASS THE NAVIGATION TO THE TOP BANNER
          TopBanner(onShopNow: () => onNavigate(1)),
          const SizedBox(height: 24),
          const AgeFilter(),
          const SizedBox(height: 24),
          const FlashSaleStrip(),
          const SizedBox(height: 24),
          CategoryGrid(onCategoryTap: onCategoryTap), // <-- Give the grid the click function
          const SizedBox(height: 24),
          NewArrivals(
            favoriteItems: favorites,
            onToggleFavorite: onToggleFavorite,
            onAddToCart: onAddToCart,
            onViewProduct: onViewProduct,
          ),
        ],
      ),
    );
  }
}
