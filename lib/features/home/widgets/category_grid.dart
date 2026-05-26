import 'package:flutter/material.dart';
import 'package:baby_store_app/theme/app_colors.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: AppColors.mint, // The light blue background for this card
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              // Layer 1: The Text on the Left
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
                // ClipRRect carves out the unique curved corners
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(
                      40,
                    ), 
                    bottomRight: Radius.circular(
                      24,
                    ), 
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

        const SizedBox(height: 16),

        // THE TOP ROW OF THE GRID ---
        Row(
          children: [
            Expanded(
              child: _buildSmallCard(
                'Safe Toys',
                Icons.toys_outlined,
                AppColors.mintLight, 
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSmallCard(
                'Feeding',
                Icons.restaurant_outlined,
                const Color(0xFFEFEBE0),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // THE BOTTOM ROW OF THE GRID ---
        Row(
          children: [
            Expanded(
              child: _buildSmallCard(
                'Gear',
                Icons.child_friendly_outlined,
                AppColors.babyPink,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSmallCard(
                'Nursery',
                Icons.bed_outlined,
                const Color(0xFFEFEBE0),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallCard(String title, IconData icon, Color bgColor) {
    return Container(
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
    );
  }
}
