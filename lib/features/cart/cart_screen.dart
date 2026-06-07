import 'package:baby_store_app/features/auth/register_screen.dart';
import 'package:baby_store_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:baby_store_app/theme/app_colors.dart';
import '../shell/main_shell_screen.dart';
import 'package:baby_store_app/features/cart/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final List<Map<String, String>> favorites;
  final String? couponCode;
  final void Function(int tabIndex)? onNavigate;
  final bool isTab;

  const CartScreen({
    super.key,
    required this.cartItems,
    this.favorites = const [],
    this.couponCode,
    this.onNavigate,
    this.isTab = false,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Map<String, dynamic>> cartItems;
  late TextEditingController _couponController;
  late FocusNode _couponFocusNode;
  String? appliedCoupon;
  double discountAmount = 0.0;

  static const Map<String, dynamic> _coupons = {
    'WELCOME20': {'type': 'percentage', 'value': 20},
    'WHEELS50': {'type': 'fixed', 'value': 50},
    'B3G1FREE': {'type': 'percentage', 'value': 25},
  };

  void _goToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CheckoutScreen(cartItems: cartItems, total: total),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant CartScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.couponCode != oldWidget.couponCode &&
        widget.couponCode != null &&
        widget.couponCode!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _couponController.text = widget.couponCode!;
        _applyCoupon(widget.couponCode!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    cartItems = widget.cartItems;
    _couponController = TextEditingController(text: widget.couponCode ?? '');
    _couponFocusNode = FocusNode();

    if (widget.couponCode != null && widget.couponCode!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _applyCoupon(widget.couponCode!);
      });
    }
  }

  @override
  void dispose() {
    _couponController.dispose();
    _couponFocusNode.dispose();
    super.dispose();
  }

  double get subtotal => cartItems.fold(
    0,
    (sum, item) => sum + (item["price"] ?? 0) * (item["qty"] ?? 1),
  );

  double get total => (subtotal - discountAmount).clamp(0, double.infinity);

  void _applyCoupon(String code) {
    final coupon = _coupons[code];
    if (coupon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid coupon: "$code"'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final discount = coupon['type'] == 'percentage'
        ? subtotal * (coupon['value'] / 100)
        : (coupon['value'] as int).toDouble();

    setState(() {
      appliedCoupon = code;
      discountAmount = discount;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Coupon "$code" applied! -\$${discount.toStringAsFixed(2)}',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = cartItems.isEmpty
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

                // ── Cart items ──────────────────────────────────
                ...cartItems.map(
                  (item) => Container(
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
                              Text(
                                item["description"] ?? "Product",
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
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
                        // ── Qty stepper ───────────────────────
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
                  ),
                ),

                const SizedBox(height: 10),

                // ── Coupon ──────────────────────────────────────
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
                            hintText: "Enter code (e.g., WELCOME20)",
                            border: InputBorder.none,
                            suffixIcon: appliedCoupon != null
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => _applyCoupon(
                        _couponController.text.trim().toUpperCase(),
                      ),
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

                // ── Offers banner ───────────────────────────────
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
                        // ✅ Just switch tab — no _NavigationWrapper needed
                        onTap: () => widget.onNavigate?.call(tabPromotions),
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

                // ── Order summary ───────────────────────────────
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
                      _summaryRow(
                        "Subtotal",
                        "\$${subtotal.toStringAsFixed(2)}",
                      ),
                      const SizedBox(height: 12),
                      _summaryRow(
                        "Shipping",
                        "Free",
                        valueStyle: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (appliedCoupon != null) ...[
                        const SizedBox(height: 12),
                        _summaryRow(
                          "Coupon: $appliedCoupon",
                          "-\$${discountAmount.toStringAsFixed(2)}",
                          labelStyle: const TextStyle(
                            fontFamily: 'Nunito',
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                          valueStyle: const TextStyle(
                            fontFamily: 'Nunito',
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      _summaryRow(
                        "Total",
                        "\$${total.toStringAsFixed(2)}",
                        labelStyle: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                        valueStyle: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ── Checkout ────────────────────────────────────
                // ── Checkout ────────────────────────────────────────────
                GestureDetector(
                  onTap: () async {
                    // ✅ Check if user is registered before checkout
                    if (!AuthService.isRegistered) {
                      final result =
                          await Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                      if (!mounted) return;
                      if (result == true) {
                        AuthService.isRegistered = true;
                        // ✅ Proceed to checkout after registration
                        _goToCheckout();
                      }
                      // If user dismissed register without completing, do nothing
                    } else {
                      // ✅ Already registered — go straight to checkout
                      _goToCheckout();
                    }
                  },
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
                          Text(
                            "Checkout",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
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

    // ✅ Tab mode — shell owns header/footer
    if (widget.isTab) return body;

    // ✅ Route mode — needs own Scaffold
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(child: body),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    TextStyle? labelStyle,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle ?? const TextStyle(fontFamily: 'Nunito')),
        Text(value, style: valueStyle ?? const TextStyle(fontFamily: 'Nunito')),
      ],
    );
  }
}
