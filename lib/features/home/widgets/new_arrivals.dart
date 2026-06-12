import 'package:flutter/material.dart';
import 'package:baby_store_app/theme/app_colors.dart';

import '../../detail/product_detail_screen.dart';

class NewArrivals extends StatelessWidget {
  final List<Map<String, String>> favoriteItems;
  final Function(Map<String, String>) onToggleFavorite;
  final Function(List<Map<String, dynamic>>) onAddToCart;
  final Function(Map<String, dynamic>) onViewProduct;

  const NewArrivals({
    super.key,
    required this.favoriteItems,
    required this.onToggleFavorite,
    required this.onAddToCart,
    required this.onViewProduct,
  });

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
                context,
                category: 'Knitted Collection',
                title: 'Cloud Soft Booties',
                price: '\$24.00',
                imagePath: 'assets/images/product/img3.png',
              ),
              const SizedBox(width: 16),

              _buildProductCard(
                context,
                category: 'Safe Toys',
                title: 'Dreamy Teddy Bear',
                price: '\$35.00',
                imagePath: 'assets/images/product/img2.png',
              ),
              const SizedBox(width: 16),

              _buildProductCard(
                context,
                category: 'Nursery',
                title: 'Cozy Baby Blanket',
                price: '\$45.00',
                imagePath: 'assets/images/product/img3.png',
              ),
              const SizedBox(width: 16),

              _buildProductCard(
                context,
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

  Widget _buildProductCard(
    BuildContext context, {
    required String category,
    required String title,
    required String price,
    required String imagePath,
  }) {
    final bool isSaved = favoriteItems.any((item) => item['title'] == title);

    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ProductDetailsScreen(
        //     product: {'title': title, 'price': price, 'image': imagePath, 'category': category},
        //       onAddToCart: onAddToCart, // ✅ PASS THE FUNCTION HERE
        //   ),
        //   ),
        // );
        // <-- CHANGED THIS PART
        onViewProduct({
          'title': title, 
          'price': price, 
          'image': imagePath, 
          'category': category
        });
      },

      child: Container(
        width: 160,
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

                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      // ✅ Just toggle — icon updates, no navigation
                      onToggleFavorite({
                        'title': title,
                        'category': category,
                        'price': price,
                        'image': imagePath,
                        'description': category,
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSaved ? Icons.favorite : Icons.favorite_border,
                        color: Colors.redAccent,
                        size: 18,
                      ),
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
                    maxLines: 1,
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
      ),
    );
  }
}
