import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class PromotionsScreen extends StatelessWidget {
  final Function(String)? onCouponApplied;

  const PromotionsScreen({super.key, this.onCouponApplied});

  @override
  Widget build(BuildContext context) {
    // ── No Scaffold, no AppBar — shell owns those ──
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Coupons',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Top buttons ─────────────────────────────────────────
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
                      "My Coupons",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
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
                      "Baby Registry",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          _buildCouponCard(
            context: context,
            title: "Welcome Gift",
            subtitle: "20% off your first nursery furniture order.",
            code: "WELCOME20",
            tag: "Free Shipping",
            icon: Icons.local_offer_outlined,
          ),
          const SizedBox(height: 18),
          _buildCouponCard(
            context: context,
            title: "Stroller Sale",
            subtitle: "\$50 off any Travel System purchase.",
            code: "WHEELS50",
            tag: "Limited Time",
            icon: Icons.card_giftcard_outlined,
          ),
          const SizedBox(height: 18),
          _buildCouponCard(
            context: context,
            title: "Bundle Jug",
            subtitle: "Buy 3 outfits, get the 4th for free.",
            code: "B3G1FREE",
            tag: "Free Shipping",
            icon: Icons.auto_awesome_outlined,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildCouponCard({
    //helper method to build the same coupon card
    required BuildContext context, //parameters for the card content
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
                    fontFamily: 'Nunito',
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
              fontFamily: 'Poppins',
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 15,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1EEE3),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  code,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),

              const Spacer(), // Push Apply button to the right

              GestureDetector(
                onTap: () {
                  if (onCouponApplied != null) {
                    onCouponApplied!(code);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5CFE1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Apply", style: TextStyle(fontFamily: 'Nunito')),
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
