import 'package:flutter/material.dart';
import '../promotions/promotions_screen.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final String? couponCode;

  const CartScreen({super.key, required this.cartItems, this.couponCode});

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

    // Auto-focus on coupon field if couponCode is provided
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
      backgroundColor: const Color(0xFFF6F1E7),

      body: SafeArea(
        child: Column(
          children: [
            // ================= TOP BAR =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF4A6072),
                    ),
                  ),
                  const Text(
                    "TinyTots",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A6072),
                      fontSize: 18,
                    ),
                  ),
                  const Icon(
                    Icons.shopping_cart_outlined,
                    color: Color(0xFF4A6072),
                  ),
                ],
              ),
            ),

            // ================= BODY =================
            Expanded(
              child: cartItems.isEmpty
                  ? const Center(
                      child: Text(
                        "Your cart is empty 🛒",
                        style: TextStyle(
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

                          // TITLE
                          const Text(
                            "My Cart",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A6072),
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            "You're \$15 away from free gift wrap!",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 25),

                          // ================= CART ITEMS =================
                          ...cartItems.map((item) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 18),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item["title"],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item["description"] ?? "Product",
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "\$${item["price"]}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // QTY
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDCEAF5),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (item["qty"] > 1) {
                                                item["qty"]--;
                                              }
                                            });
                                          },
                                          child: const Icon(
                                            Icons.remove,
                                            size: 18,
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
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              item["qty"]++;
                                            });
                                          },
                                          child: const Icon(
                                            Icons.add,
                                            size: 18,
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

                          // ================= COUPON =================
                          const Text(
                            "Apply a coupon",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4A6072),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
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
                                child: const Text("Apply"),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // ================= OFFER =================
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Exclusive Deals for You!",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF4A6072),
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        "Save more with today's special bundles.",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PromotionsScreen(),
                                      ),
                                    );
                                  },
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
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 25),

                          // ================= ORDER SUMMARY =================
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
                                  child: Text("Order Summary"),
                                ),
                                const SizedBox(height: 20),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Subtotal"),
                                    Text("\$${subtotal.toStringAsFixed(2)}"),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Shipping"),
                                    Text(
                                      "Free",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 18),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Total",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      "\$${subtotal.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // ================= CHECKOUT =================
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              color: const Color(0xFF556B7B),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: const Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min, // ⭐ IMPORTANT
                                children: [
                                  Text(
                                    "Checkout",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 6),

                                  // ➜ ARROW SIGN
                                  Text(
                                    "➜",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),

      // ================= FOOTER =================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // HOME
            GestureDetector(
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.home_outlined),
                  SizedBox(height: 4),
                  Text("Home"),
                ],
              ),
            ),
            // SHOP
            const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.storefront_outlined),
                SizedBox(height: 4),
                Text("Shop"),
              ],
            ),
            // CART
            const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFFDCEAF5),
                  child: Icon(Icons.shopping_cart_outlined),
                ),
                SizedBox(height: 4),
                Text("Cart"),
              ],
            ),
            // PROFILE
            const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_outline),
                SizedBox(height: 4),
                Text("Profile"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
