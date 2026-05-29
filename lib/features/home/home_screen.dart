import 'package:flutter/material.dart';
import 'widgets/home_widgets.dart';
import 'widgets/category_grid.dart';
import 'widgets/new_arrivals.dart';

// HomeBody has no Scaffold, no drawer — just the ListView content
class HomeBody extends StatelessWidget {
  final List<Map<String, String>> favorites;
  final void Function(Map<String, String>) onToggleFavorite;

  const HomeBody({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          NewArrivals(
            favoriteItems: favorites,
            onToggleFavorite: onToggleFavorite,
          ),
        ],
      ),
    );
  }
}
