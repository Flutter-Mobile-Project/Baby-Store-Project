import 'package:flutter/material.dart';
import 'package:baby_store_app/theme/app_colors.dart';
import '../promotions/promotions_screen.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final String? couponCode;
  final VoidCallback? onBack; // 👈 Add this line

  const CartScreen({
    super.key,
    required this.cartItems,
    this.couponCode,
    this.onBack,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Map<String, dynamic>> cartItems;
  late TextEditingController _couponController;
  late FocusNode _couponFocusNode;

  @override
  void initState() {
    super.initState();
    cartItems = widget.cartItems;
    _couponController = TextEditingController();
    _couponFocusNode = FocusNode();
    if (widget.couponCode != null) {
      _couponController.text = widget.couponCode!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _couponFocusNode.requestFocus();
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
    return Scaffold(
      backgroundColor: AppColors.cream,

      // ── Shared-style AppBar ─────────────────────────────────────
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'TinyTots',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${cartItems.length}'),
              isLabelVisible: cartItems.isNotEmpty,
              backgroundColor: Colors.redAccent,
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.textPrimary,
              ),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ── Body ───────────────────────────────────────────────────
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty 🛒",
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
                          // ── Qty stepper ─────────────────────────
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
                            decoration: const InputDecoration(
                              hintText: "Enter code (e.g., WELCOME)",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
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
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PromotionsScreen(),
                            ),
                          ),
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
                              "View Special\nOffers ➜",
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
                              "\$${subtotal.toStringAsFixed(2)}",
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

                  // ── Checkout button ─────────────────────────────
                  GestureDetector(
                    onTap: () {
                      // TODO: wire to checkout screen
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
                            SizedBox(width: 6),
                            Text(
                              "➜",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}
