import 'package:flutter/material.dart';
import 'package:baby_store_app/theme/app_colors.dart';

class NewArrivals extends StatelessWidget {
  const NewArrivals({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text(
              'New Arrivals',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'View All',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 260,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              _buildProductCard(
                category: 'Knitted Collection',
                title: 'Cloud Soft Booties',
                price: '\$24.00',
                imagePath: 'assets/images/product/img3.png',
              ),
              const SizedBox(width: 16), // Space between cards
              _buildProductCard(
                category: 'Safe Toys',
                title: 'Dreamy Teddy Bear',
                price: '\$35.00',
                imagePath: 'assets/images/product/img2.png',
              ),
              const SizedBox(width: 16),
              _buildProductCard(
                category: 'Nursery',
                title: 'Cozy Baby Blanket',
                price: '\$45.00',
                imagePath: 'assets/images/product/img3.png',
              ),
              const SizedBox(width: 16),

              _buildProductCard(
                category: 'Feeding',
                title: 'Organic Bib Set',
                price: '\$15.00',
                imagePath: 'assets/images/product/img2.png',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard({
    required String category,
    required String title,
    required String price,
    required String imagePath,
  }) {
    return Container(
      width: 160, // Fixed width for each card
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
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: Image.asset(
                  imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // The floating heart icon
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.redAccent,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),

       
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1, // Prevents long names from breaking the layout
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
