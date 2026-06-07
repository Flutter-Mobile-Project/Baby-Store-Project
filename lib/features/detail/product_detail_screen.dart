import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? product;
  final Function(List<Map<String, dynamic>>) onAddToCart;

  const ProductDetailsScreen({
    super.key,
    this.product,
    required this.onAddToCart,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String _selectedColor = 'Mint';
  String _selectedSize = '0-3M';
  int _quantity = 1;

  final Map<String, String> _colorImages = {
    'Pink': 'assets/images/product/cartoonPink.png',
    'Mint': 'assets/images/product/img2.png',
    'Blue': 'assets/images/product/cartoonBlue.png',
  };

  void _handleAddToCart() {
    List<Map<String, dynamic>> itemsToAdd = [
      {
        'title': widget.product?['title'] ?? 'Organic Cotton Sleepsuit',
        'price': widget.product?['price'] ?? '\$24.00',
        'qty': _quantity,
        'color': _selectedColor,
        'size': _selectedSize,
      },
    ];

    widget.onAddToCart(itemsToAdd);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to Cart! 🛍️'),
        backgroundColor: Color(0xFF556672),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.textPrimary),
            onPressed: _handleAddToCart,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          // IMAGE SECTION
          Stack(
            children: [
              Container(
                height: 380,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  image: DecorationImage(
                    image: AssetImage(_colorImages[_selectedColor]!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  radius: 20,
                  child: const Icon(
                    Icons.zoom_in,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // REVIEWS & TITLE
          Row(
            children: [
              Row(
                children: List.generate(
                  5,
                  (index) => const Icon(
                    Icons.star,
                    color: Color(0xFFFFD700),
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '(124 Reviews)',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Organic Cotton Sleepsuit',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // PRICE
          Row(
            children: [
              const Text(
                '\$24.00',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '\$35.00',
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // COLOR SELECTION
          Text(
            'COLOR: ${_selectedColor.toUpperCase()}',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildColorSelector(AppColors.babyPink, 'Pink'),
              const SizedBox(width: 12),
              _buildColorSelector(AppColors.mint, 'Mint'),
              const SizedBox(width: 12),
              _buildColorSelector(AppColors.babyBlue, 'Blue'),
            ],
          ),
          const SizedBox(height: 24),

          // SIZE SELECTION
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'SIZE SELECTION',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Size Guide',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              '0-3M',
              '3-6M',
              '6-9M',
              '9-12M',
            ].map((s) => _buildSizePill(s)).toList(),
          ),
          const SizedBox(height: 24),

          // QUANTITY
          const Text(
            'QUANTITY',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 120,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.beige,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () =>
                      setState(() => _quantity > 1 ? _quantity-- : null),
                  child: const Icon(Icons.remove, size: 20),
                ),
                Text(
                  '$_quantity',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _quantity++),
                  child: const Icon(Icons.add, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // TAGS
          Row(
            children: [
              Expanded(
                child: _buildTag(
                  AppColors.mint,
                  Icons.eco_outlined,
                  '100% GOTS\nCotton',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTag(
                  AppColors.babyPink,
                  Icons.water_drop_outlined,
                  'Machine\nWashable',
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.cream,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              // --- SMART HEART BUTTON ---
              GestureDetector(
                onTap: () {
                  // 1. Show feedback popup without navigating away
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Added to Favorites ❤️',
                        style: TextStyle(fontFamily: 'Nunito'),
                      ),
                      backgroundColor: AppColors.mint,
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.textPrimary),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border),
                ),
              ),
              const SizedBox(width: 16),

              // --- ADD TO CART BUTTON ---
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF556672),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    onPressed: () {
                      // 2. Logic: Print or save to your Global Cart list
                      print(
                        "Added to cart: $_selectedColor, $_selectedSize, Qty: $_quantity",
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Added to Cart! 🛍️',
                            style: TextStyle(fontFamily: 'Nunito'),
                          ),
                          backgroundColor: Color(0xFF556672),
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorSelector(Color color, String colorName) {
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = colorName),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedColor == colorName
                ? AppColors.textPrimary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: CircleAvatar(backgroundColor: color, radius: 16),
      ),
    );
  }

  Widget _buildSizePill(String size) {
    return GestureDetector(
      onTap: () => setState(() => _selectedSize = size),
      child: Container(
        width: 75,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: _selectedSize == size
              ? AppColors.babyBlue
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _selectedSize == size
                ? Colors.transparent
                : Colors.grey.shade400,
          ),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              fontWeight: _selectedSize == size
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(Color bgColor, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
