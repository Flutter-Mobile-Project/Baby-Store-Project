import 'package:baby_store_app/data/mock_product.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ShopScreen extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteItems;
  final Function(Map<String, String>) onToggleFavorite;
  final Function(List<Map<String, dynamic>>) onAddToCart;
  final Function(Map<String, dynamic>) onViewProduct;
  final String selectedCategory;

  const ShopScreen({
    super.key,
    required this.favoriteItems,
    required this.onToggleFavorite,
    required this.onAddToCart,
    required this.onViewProduct,
    this.selectedCategory = 'All',
  });

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String _activeCategory = 'All';

  // 1. REMOVED 'All' FROM THIS LIST
  final List<String> _categories = [
    'Soft Clothing',
    'Safe Toys',
    'Feeding',
    'Gear',
    'Nursery',
  ];

  @override
  void initState() {
    super.initState();
    _activeCategory = widget.selectedCategory;
  }

  @override
  void didUpdateWidget(ShopScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      setState(() => _activeCategory = widget.selectedCategory);
    }
  }

  List get _filteredProducts {
    List filtered = products.where((product) {
      return product.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (_activeCategory != 'All') {
      filtered = filtered
          .where((product) => product.brand.contains(_activeCategory))
          .toList();
    }

    if (_selectedFilter == 'A-Z') {
      filtered.sort((a, b) => a.title.compareTo(b.title));
    }

    if (_selectedFilter == 'Price ↑') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    }

    if (_selectedFilter == 'Price ↓') {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    }

    return filtered;
  }

  Widget _filterChip(String label) {
    // 2. NEW LOGIC: The "All" chip is only blue if BOTH sorting and category are cleared
    final selected = label == 'All'
        ? (_selectedFilter == 'All' && _activeCategory == 'All')
        : _selectedFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            // 3. MASTER RESET: Clicking "All" clears the sorting AND the dropdown
            if (label == 'All') {
              _selectedFilter = 'All';
              _activeCategory = 'All';
            } else {
              _selectedFilter = label;
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF556B7B) : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search baby products...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 14),

            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _filterChip('All'),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: PopupMenuButton<String>(
                      onSelected: (val) {
                        setState(() {
                          _activeCategory = val;
                        });
                      },
                      offset: const Offset(0, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      itemBuilder: (context) => _categories
                          .map(
                            (cat) =>
                                PopupMenuItem(value: cat, child: Text(cat)),
                          )
                          .toList(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _activeCategory != 'All'
                              ? const Color(0xFF556B7B)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _activeCategory == 'All'
                                  ? 'Categories'
                                  : _activeCategory,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: _activeCategory != 'All'
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 18,
                              color: _activeCategory != 'All'
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  
                  _filterChip('A-Z'),
                  _filterChip('Price ↑'),
                  _filterChip('Price ↓'),
                ],
              ),
            ),

            const SizedBox(height: 16),
            // --- NEW: EMPTY STATE CHECK ---
            if (_filteredProducts.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off_rounded, 
                        size: 80, 
                        color: Colors.grey.shade400
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Oops! Nothing found.",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Try a different search or category.",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                final bool isSaved = widget.favoriteItems.any(
                  (item) => item['title'] == product.title,
                );

                return GestureDetector(
                  onTap: () {
                    widget.onViewProduct({
                      'title': product.title,
                      'price': '\$${product.price.toStringAsFixed(2)}',
                      'image': product.image,
                      'category': product.brand,
                    });
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
