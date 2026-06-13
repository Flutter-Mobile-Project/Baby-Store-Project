import 'dart:async'; // Add this at the very top of the file!
import 'package:flutter/material.dart';
import 'package:baby_store_app/theme/app_colors.dart';

class TopBanner extends StatefulWidget {
  final VoidCallback onShopNow;
  const TopBanner({super.key, required this.onShopNow});

  @override
  State<TopBanner> createState() => _TopBannerState();
}

class _TopBannerState extends State<TopBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  // Here you can add as many banners as you want!
  // Just change the image paths to pictures you actually have in your assets.
  final List<Map<String, String>> _banners = [
    {
      'image': 'assets/images/banner_baby.jpg', // Your original image
      'title': 'Gentle Care for\nTiny Smiles',
      'subtitle': 'Organic essentials for your little ones.',
    },
    {
      'image':
          'assets/images/banner_baby.png', 
      'title': 'On The Go\nMade Easy',
      'subtitle': 'Premium gear for everyday adventures.',
    },
    {
      'image':
          'assets/images/banner3.png', 
      'title': 'Snuggle Time\nEveryday',
      'subtitle': 'Softest fabrics for delicate skin.',
    },
  ];

  @override
  void initState() {
    super.initState();
    // This timer makes the banner auto-scroll every 4 seconds!
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < _banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // Loop back to the first image
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Always clean up timers
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: Stack(
          children: [
            // --- THE SLIDING IMAGES ---
            PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: _banners.length,
              itemBuilder: (context, index) {
                final banner = _banners[index];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(banner['image']!, fit: BoxFit.cover),
                    // Gradient overlay to make text readable
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.9),
                            Colors.white.withOpacity(0.1),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                    // The Text and Button for each slide
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            banner['title']!,
                            style: const TextStyle(
                              fontSize: 22,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            banner['subtitle']!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Nunito',
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: widget.onShopNow,
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
                );
              },
            ),

            // --- THE ANIMATED DOTS AT THE BOTTOM ---
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _banners.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index
                        ? 24
                        : 8, // Stretches the active dot
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? const Color(0xFF5C7282)
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
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
class FlashSaleStrip extends StatefulWidget {
  const FlashSaleStrip({super.key});

  @override
  State<FlashSaleStrip> createState() => _FlashSaleStripState();
}

// The 'SingleTickerProviderStateMixin' is required for the pulsing animation!
class _FlashSaleStripState extends State<FlashSaleStrip> with SingleTickerProviderStateMixin {
  late Timer _timer;
  Duration _timeLeft = const Duration(hours: 2, minutes: 45, seconds: 8);

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // 1. START THE COUNTDOWN TIMER
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        setState(() {
          _timeLeft -= const Duration(seconds: 1);
        });
      } else {
        _timer.cancel(); // Stop when it hits zero!
      }
    });

    // 2. START THE INFINITE PULSE ANIMATION FOR THE BADGE
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Speed of the heartbeat
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true); // Makes it go big, then small, forever
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Helper to format the time into two digits (e.g., '09' instead of '9')
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(_timeLeft.inHours);
    final minutes = twoDigits(_timeLeft.inMinutes.remainder(60));
    final seconds = twoDigits(_timeLeft.inSeconds.remainder(60));

    return Container(
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.babyPink, Colors.white.withOpacity(0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.babyPink.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // --- THE TEXT AND LIVE TIMER (Left Side) ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: const [
                    Icon(Icons.local_fire_department_rounded, color: Colors.deepOrangeAccent, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Flash Sale',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Up to 40% Off Select Toys',
                  style: TextStyle(fontFamily: 'Nunito', color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 16),

                // The LIVE Animated Timer
                Row(
                  children: [
                    _buildTimeBox(hours, 'HRS'),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(':', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                    ),
                    _buildTimeBox(minutes, 'MIN'),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(':', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                    ),
                    _buildTimeBox(seconds, 'SEC'),
                  ],
                ),
              ],
            ),
          ),

          // --- THE PRODUCT IMAGE (Right Side) ---
          Positioned(
            right: 10,
            bottom: 0,
            top: 10,
            child: Image.asset(
              'assets/images/category/teddy.png', 
              width: 110,
              fit: BoxFit.contain,
            ),
          ),

          // --- THE ANIMATED PULSING DISCOUNT BADGE ---
          Positioned(
            right: 20,
            top: 20,
            child: ScaleTransition(
              scale: _pulseAnimation, // This makes the badge breathe!
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.redAccent.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                  ]
                ),
                child: const Text(
                  '-40%',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Poppins'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBox(String time, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
          ),
          child: Text(
            time,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.redAccent),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 9, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}