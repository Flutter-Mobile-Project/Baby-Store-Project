import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../cart/cart_screen.dart';

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F3E7),
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.grey),
        title: const Text(
          "TinyTots",
          style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.shopping_cart_outlined, color: Colors.blueGrey),
          ),
        ],
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== TOP BUTTONS =====
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCEEFF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        "My\nCoupons",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1EEE3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        "Baby\nRegistry",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            buildCouponCard(
              context: context,
              title: "Welcome Gift",
              subtitle: "20% off your first nursery furniture order.",
              code: "WELCOME20",
              tag: "Free Shipping",
              icon: Icons.local_offer_outlined,
            ),

            const SizedBox(height: 18),

            buildCouponCard(
              context: context,
              title: "Stroller Sale",
              subtitle: "\$50 off any Travel System purchase.",
              code: "WHEELS50",
              tag: "Limited Time",
              icon: Icons.card_giftcard_outlined,
            ),

            const SizedBox(height: 18),

            buildCouponCard(
              context: context,
              title: "Bundle Jug",
              subtitle: "Buy 3 outfits, get the 4th for free.",
              code: "B3G1FREE",
              tag: "Free Shipping",
              icon: Icons.auto_awesome_outlined,
            ),
          ],
        ),
      ),

      // ================= FOOTER =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        backgroundColor: const Color(0xFFF8F3E7),
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            label: "Shop",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: "Registry",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  // ================= COUPON CARD =================
  Widget buildCouponCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String code,
    required String tag,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4E1EC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
              Icon(icon, color: Colors.blueGrey),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            subtitle,
            style: const TextStyle(fontSize: 17, color: Colors.black54),
          ),

          const SizedBox(height: 24),

          // BOTTOM ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1EEE3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  code,
                  style: const TextStyle(
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),

              // ================= APPLY BUTTON =================
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CartScreen(cartItems: [], couponCode: code),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5CFE1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Apply"),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
