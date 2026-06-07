import 'package:baby_store_app/models/product.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../detail/product_detail_screen.dart';

class ShopScreen extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteItems;
  final Function(Map<String, String>) onToggleFavorite;
  final Function(List<Map<String, dynamic>>) onAddToCart;

  const ShopScreen({
    super.key,
    required this.favoriteItems,
    required this.onToggleFavorite,
    required this.onAddToCart,
  });

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
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
            const Text(
              "Baby Essentials",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
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
                final bool isSaved = widget.favoriteItems.any(
                  (item) => item['title'] == product.title,
                );

                return GestureDetector(
                  onTap: () {
                    // ✅ FIXED: Pass the real onAddToCart function here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          product: {
                            'title': product.title,
                            'price': '\$${product.price.toStringAsFixed(2)}',
                            'image': product.image,
                            'category': product.brand,
                          },
                          onAddToCart: widget
                              .onAddToCart, // <--- This connects the bridge
                        ),
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
                        Expanded(
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: Image.asset(
                                    product.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    widget.onToggleFavorite({
                                      'title': product.title,
                                      'category': product.brand,
                                      'price': product.price.toStringAsFixed(2),
                                      'image': product.image,
                                    });
                                  },
                                  child: Container(
                                    height: 36,
                                    width: 36,
                                    decoration: const BoxDecoration(
                                      color: Colors.white70,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isSaved
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 20,
                                      color: isSaved
                                          ? Colors.red
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product.brand,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black38,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "\$${product.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
