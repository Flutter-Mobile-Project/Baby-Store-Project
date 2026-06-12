import 'package:flutter/material.dart';
import 'package:baby_store_app/theme/app_colors.dart';

class CategoryGrid extends StatelessWidget {
  final Function(String) onCategoryTap; // <-- 1. Added a function to listen for clicks!

  const CategoryGrid({super.key, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 2. Wrapped the big card in a GestureDetector
        GestureDetector(
          onTap: () => onCategoryTap('Soft Clothing'),
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.mint, 
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Soft Clothing',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '100% Organic Cotton',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40), 
                      bottomRight: Radius.circular(24), 
                    ),
                    child: Image.asset(
                      'assets/images/soft_clothing.png', 
                      width: 140,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // THE TOP ROW OF THE GRID
        Row(
          children: [
            Expanded(
              child: _buildSmallCard(
                'Safe Toys',
                Icons.toys_outlined,
                AppColors.mintLight, 
                () => onCategoryTap('Safe Toys'), // <-- 3. Pass the click!
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSmallCard(
                'Feeding',
                Icons.restaurant_outlined,
                const Color(0xFFEFEBE0),
                () => onCategoryTap('Feeding'), // <-- 3. Pass the click!
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // THE BOTTOM ROW OF THE GRID
        Row(
          children: [
            Expanded(
              child: _buildSmallCard(
                'Gear',
                Icons.child_friendly_outlined,
                AppColors.babyPink,
                () => onCategoryTap('Gear'), // <-- 3. Pass the click!
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSmallCard(
                'Nursery',
                Icons.bed_outlined,
                const Color(0xFFEFEBE0),
                () => onCategoryTap('Nursery'), // <-- 3. Pass the click!
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Updated this widget to accept "onTap"
  Widget _buildSmallCard(String title, IconData icon, Color bgColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: AppColors.textPrimary),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Nunito',
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}