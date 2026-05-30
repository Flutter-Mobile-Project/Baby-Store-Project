import 'package:baby_store_app/models/product.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../detail/product_detail_screen.dart';
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🧸 Fixed: Instantiating actual Product objects instead of raw Maps
    final List<Product> products = [
      Product(
        brand: "SILKYCARE",
        title: "Anti-Colic Bottle",
        price: 24.00,
        image: "assets/images/category/bottle.png",
      ),
      Product(
        brand: "CLOUDCOTTON",
        title: "Organic Onesie",
        price: 32.00,
        image: "assets/images/category/onesie.png",
      ),
      Product(
        brand: "WOODYTOY",
        title: "Natural Beech Rattle",
        price: 18.50,
        image: "assets/images/category/rattle.png",
      ),
      Product(
        brand: "HUGGYBUDDY",
        title: "Sage Plush Friend",
        price: 28.00,
        image: "assets/images/category/teddy.png",
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🏷️ Header Block
            const Text(
              "Baby Essentials",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Gentle products for your little one's big moments. Curated with love and safety in mind.",
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: Colors.black54,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),

            // 🎛️ Filter and Sort Controls
            Row(
              children: [
                _buildActionButton(Icons.tune, "Filter"),
                const SizedBox(width: 10),
                _buildActionButton(Icons.swap_vert, "Sort"),
              ],
            ),
            const SizedBox(height: 20),

            // 🛍️ Product Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                final product = products[index];

                // --- ADDED GESTURE DETECTOR HERE ---
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductDetailsScreen(),
                      ),
                    );
                  },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 📸 Image Container with Absolute Positioned Heart Button
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: Image.asset(
                                  product.image, // ✨ Fixed: Uses dot notation
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                height: 36,
                                width: 36,
                                decoration: const BoxDecoration(
                                  color: Colors.white70,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.favorite_border,
                                  size: 20,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 📝 Product Information Metadata
                      Text(
                        product.brand, // ✨ Fixed: Uses dot notation
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.black38,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.title, // ✨ Fixed: Uses dot notation
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "\$${product.price.toStringAsFixed(2)}", // ✨ Fixed: Uses dot notation
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                );
              },
              
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EFEA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textPrimary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
