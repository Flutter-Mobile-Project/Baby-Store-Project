import 'package:flutter/material.dart';
import 'package:baby_store_app/theme/app_colors.dart';

class TopBanner extends StatelessWidget {
  final VoidCallback onShopNow;
  const TopBanner({super.key, required this.onShopNow});

  @override
  Widget build(BuildContext context) {
    // ClipRRect strictly cuts off anything outside the 24px border radius
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: Stack(
          children: [
            // --- LAYER 1: The Background Image ---
            Positioned.fill(
              child: Image.asset(
                'assets/images/banner_baby.jpg',
                fit: BoxFit.cover,
              ),
            ),

            // --- LAYER 2: The Gradient Overlay ---
            // This adds a smooth white fade on the left side so text is readable
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(
                        0.9,
                      ), // 90% solid white on the left
                      Colors.white.withOpacity(
                        0.1,
                      ), // Almost invisible on the right
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),

            // --- LAYER 3: The Text and Button ---
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Gentle Care for\nTiny Smiles',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Organic essentials for your little ones.',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Nunito',
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: onShopNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5C7282),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Shop Now',
                      style: TextStyle(fontFamily: 'Nunito'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AgeFilter extends StatelessWidget {
  const AgeFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final ages = ['0-6m', '6-12m', '1-2y', '2-4y'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ages.map((age) {
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Chip(
              label: Text(
                age,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: Colors.white,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class FlashSaleStrip extends StatelessWidget {
  const FlashSaleStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.babyPink, // The soft pink from your theme!
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: The Icon and Title
          Row(
            children: const [
              Icon(Icons.flash_on, color: Colors.black54),
              SizedBox(width: 8),
              Text(
                'Flash Sale',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const Text(
            'Up to 40% Off Select Toys',
            style: TextStyle(
              fontFamily: 'Nunito',
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),

          //  The Countdown Timer Boxes
          Row(
            children: [
              _buildTimeBox('02', 'HRS'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              _buildTimeBox('45', 'MIN'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              _buildTimeBox('08', 'SEC'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBox(String time, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            time,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 8, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
