import 'package:flutter/material.dart';
import 'package:baby_store_app/theme/app_colors.dart';
import '../shell/main_shell_screen.dart';
import '../shell/widgets/app_header.dart';
import '../shell/widgets/app_footer.dart';
import '../home/home_screen.dart';
import '../shop/shop_screen.dart';
import '../favorites/favorites_screen.dart';
import '../settings/settings_screen.dart';
import '../promotions/promotions_screen.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final List<Map<String, String>> favorites;
  final String? couponCode;
  final void Function(int tabIndex)? onNavigate; // ← to switch tabs
  final bool isTab; // ✅ explicit mode

  const CartScreen({
    super.key,
    required this.cartItems,
    this.favorites = const [],
    this.couponCode,
    this.onNavigate,
    this.isTab = false, // default: pushed route
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Map<String, dynamic>> cartItems;
  late List<Map<String, String>> favorites;
  late TextEditingController _couponController;
  late FocusNode _couponFocusNode;
  String? appliedCoupon;
  double discountAmount = 0.0;

  // Coupon discount mapping
  static const Map<String, dynamic> couponDiscounts = {
    'WELCOME20': {'type': 'percentage', 'value': 20}, // 20% off
    'WHEELS50': {'type': 'fixed', 'value': 50}, // $50 off
    'B3G1FREE': {'type': 'percentage', 'value': 25}, // Approximate 25% off
  };

  void _toggleFavorite(Map<String, String> item) {
    setState(() {
      final exists = favorites.any((e) => e['title'] == item['title']);
      if (exists) {
        favorites.removeWhere((e) => e['title'] == item['title']);
      } else {
        favorites.add(item);
      }
    });
  }

  double _calculateDiscount(String couponCode, double subtotal) {
    if (!couponDiscounts.containsKey(couponCode)) {
      return 0.0;
    }

    final discount = couponDiscounts[couponCode];
    if (discount['type'] == 'percentage') {
      return subtotal * (discount['value'] / 100);
    } else if (discount['type'] == 'fixed') {
      return discount['value'].toDouble();
    }
    return 0.0;
  }

  void _handleNavigation(int tabIndex) {
    if (widget.isTab) {
      // When used as a tab in the shell, use the onNavigate callback
      widget.onNavigate?.call(tabIndex);
    } else {
      // When used as a standalone route, replace with the appropriate screen
      // Create a NEW StatefulWidget wrapper to avoid disposed state issues
      switch (tabIndex) {
        case tabHome:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => _NavigationWrapper(
                selectedTab: tabHome,
                favorites: favorites,
                cartItems: cartItems,
                onNavigate: _handleNavigation,
              ),
            ),
          );
          break;
        case tabShop:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => _NavigationWrapper(
                selectedTab: tabShop,
                favorites: favorites,
                cartItems: cartItems,
                onNavigate: _handleNavigation,
              ),
            ),
          );
          break;
        case tabFavorites:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => _NavigationWrapper(
                selectedTab: tabFavorites,
                favorites: favorites,
                cartItems: cartItems,
                onNavigate: _handleNavigation,
              ),
            ),
          );
          break;
        case tabProfile:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => _NavigationWrapper(
                selectedTab: tabProfile,
                favorites: favorites,
                cartItems: cartItems,
                onNavigate: _handleNavigation,
              ),
            ),
          );
          break;
        case tabPromotions:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => _NavigationWrapper(
                selectedTab: tabPromotions,
                favorites: favorites,
                cartItems: cartItems,
                onNavigate: _handleNavigation,
              ),
            ),
          );
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    cartItems = widget.cartItems;
    favorites = List.from(widget.favorites); // Make a mutable copy
    _couponController = TextEditingController();
    _couponFocusNode = FocusNode();

    // Auto-fill coupon code if passed from promotions
    if (widget.couponCode != null && widget.couponCode!.isNotEmpty) {
      _couponController.text = widget.couponCode!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Auto-apply the coupon
        String code = widget.couponCode!;
        double subtotal = 0;
        for (var item in cartItems) {
          subtotal += (item["price"] ?? 0) * (item["qty"] ?? 1);
        }
        double discount = _calculateDiscount(code, subtotal);
        if (discount > 0) {
          setState(() {
            appliedCoupon = code;
            discountAmount = discount;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _couponController.dispose();
    _couponFocusNode.dispose();
    super.dispose();
  }

  double get subtotal {
    double total = 0;
    for (var item in cartItems) {
      total += (item["price"] ?? 0) * (item["qty"] ?? 1);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = cartItems.isEmpty
        ? const Center(
            child: Text(
              "Your cart is empty",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "My Cart",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "You're \$15 away from free gift wrap!",
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 25),

                // ── Cart items ──────────────────────────────────────
                ...cartItems.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            item["image"],
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["title"],
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item["description"] ?? "Product",
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "\$${item["price"]}",
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ── Qty stepper ─────────────────────────────
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.babyBlue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => setState(() {
                                  if (item["qty"] > 1) item["qty"]--;
                                }),
                                child: const Icon(
                                  Icons.remove,
                                  size: 18,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  item["qty"].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => item["qty"]++),
                                child: const Icon(
                                  Icons.add,
                                  size: 18,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 10),

                // ── Coupon ──────────────────────────────────────────
                const Text(
                  "Apply a coupon",
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: _couponController,
                          focusNode: _couponFocusNode,
                          decoration: InputDecoration(
                            hintText: "Enter code (e.g., WELCOME)",
                            border: InputBorder.none,
                            suffixIcon:
                                appliedCoupon != null && discountAmount > 0
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        String code = _couponController.text.trim();
                        if (code.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a coupon code'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        double discount = _calculateDiscount(code, subtotal);
                        if (discount > 0) {
                          setState(() {
                            appliedCoupon = code;
                            discountAmount = discount;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Coupon "$code" applied! Discount: \$${discount.toStringAsFixed(2)}',
                              ),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Invalid coupon code: "$code"'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5CFE1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Apply",
                          style: TextStyle(fontFamily: 'Nunito'),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // ── Offers banner ───────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBCFE0),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Exclusive Deals for You!",
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Save more with today's special bundles.",
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _handleNavigation(tabPromotions),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "View Special\nOffers",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Nunito'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // ── Order summary ───────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDEBE3),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Order Summary",
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Subtotal",
                            style: TextStyle(fontFamily: 'Nunito'),
                          ),
                          Text(
                            "\$${subtotal.toStringAsFixed(2)}",
                            style: const TextStyle(fontFamily: 'Nunito'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Shipping",
                            style: TextStyle(fontFamily: 'Nunito'),
                          ),
                          Text(
                            "Free",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      if (appliedCoupon != null && discountAmount > 0) ...[
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Coupon: $appliedCoupon",
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "-\$${discountAmount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            "\$${(subtotal - discountAmount).toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ── Checkout ────────────────────────────────────────
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF556B7B),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Checkout",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );

    if (widget.isTab) return body;
    // ✅ Wrap in Scaffold only when pushed as a route
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppHeader(
        cartItemCount: cartItems.length,
        onCartPressed: () => widget.onNavigate?.call(tabCart),
        onSearchPressed: () {},
        onMenuPressed: () => Navigator.of(context).pop(),
      ),
      body: body,
      bottomNavigationBar: AppFooter(
        selectedIndex: tabCart,
        favoritesCount: favorites.length,
        onDestinationSelected: _handleNavigation,
      ),
    );
  }

  // ✅ As a shell tab — just return content
  // return body;
  // }
}

// ═══════════════════════════════════════════════════════════════════════════
// Separate StatefulWidget wrapper to handle navigation properly and avoid
// setState() called after dispose() errors
// ═══════════════════════════════════════════════════════════════════════════
class _NavigationWrapper extends StatefulWidget {
  final int selectedTab;
  final List<Map<String, String>> favorites;
  final List<Map<String, dynamic>> cartItems;
  final Function(int) onNavigate;

  const _NavigationWrapper({
    required this.selectedTab,
    required this.favorites,
    required this.cartItems,
    required this.onNavigate,
  });

  @override
  State<_NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<_NavigationWrapper> {
  late List<Map<String, String>> favorites;
  late int currentTab;
  String? pendingCouponCode;

  @override
  void initState() {
    super.initState();
    favorites = List.from(widget.favorites);
    currentTab = widget.selectedTab;
  }

  void _toggleFavorite(Map<String, String> item) {
    setState(() {
      final exists = favorites.any((e) => e['title'] == item['title']);
      if (exists) {
        favorites.removeWhere((e) => e['title'] == item['title']);
      } else {
        favorites.add(item);
      }
    });
  }

  void _handleWrapperNavigation(int tabIndex) {
    setState(() {
      currentTab = tabIndex;
    });
  }

  void _handleCouponFromPromotion(String couponCode) {
    setState(() {
      pendingCouponCode = couponCode;
      currentTab = tabCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    late Widget body;

    switch (currentTab) {
      case tabHome:
        body = HomeBody(
          favorites: favorites,
          onToggleFavorite: _toggleFavorite,
        );
        break;
      case tabShop:
        body = const ShopScreen();
        break;
      case tabFavorites:
        body = FavoritesScreen(
          favoriteItems: favorites,
          onFavoritesUpdated: () => setState(() {}),
        );
        break;
      case tabProfile:
        body = const SettingsScreen();
        break;
      case tabPromotions:
        body = PromotionsScreen(onCouponApplied: _handleCouponFromPromotion);
        break;
      case tabCart:
        body = CartScreen(
          cartItems: widget.cartItems,
          favorites: favorites,
          couponCode: pendingCouponCode,
          isTab: true,
          onNavigate: (index) => _handleWrapperNavigation(index),
        );
        // Clear pending coupon after using it
        pendingCouponCode = null;
        break;
      default:
        body = HomeBody(
          favorites: favorites,
          onToggleFavorite: _toggleFavorite,
        );
    }

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppHeader(
        cartItemCount: widget.cartItems.length,
        onCartPressed: () => _handleWrapperNavigation(tabCart),
        onSearchPressed: () {},
        onMenuPressed: () => Navigator.of(context).pop(),
      ),
      body: body,
      bottomNavigationBar: AppFooter(
        selectedIndex: currentTab,
        favoritesCount: favorites.length,
        onDestinationSelected: _handleWrapperNavigation,
      ),
    );
  }
}
