import 'package:flutter/material.dart';
import 'package:baby_store_app/theme/app_colors.dart';
import 'package:confetti/confetti.dart';
import '../shell/main_shell_screen.dart';

class SuccessScreen extends StatefulWidget {
  final String orderId;

  const SuccessScreen({super.key, required this.orderId});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _confettiController.play();
    _animationController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayOrderId = widget.orderId.length > 8
        ? widget.orderId.substring(0, 8).toUpperCase()
        : widget.orderId.toUpperCase();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EE),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFF8EE), Color(0xFFFFFCF6)],
              ),
            ),
          ),

          // Decorative Circle Top Right
          Positioned(
            top: -90,
            right: -70,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFDDEBE3).withOpacity(0.45),
              ),
            ),
          ),

          // Decorative Circle Bottom Left
          Positioned(
            bottom: -80,
            left: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD7A8).withOpacity(0.25),
              ),
            ),
          ),

          // Small Decoration
          Positioned(
            top: 180,
            left: 25,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange.withOpacity(0.15),
              ),
            ),
          ),

          Positioned(
            bottom: 260,
            right: 30,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.withOpacity(0.15),
              ),
            ),
          ),

          // Confetti Animation
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.03,
              numberOfParticles: 30,
              gravity: 0.15,
              colors: const [
                Colors.green,
                Colors.orange,
                Colors.pink,
                Colors.blue,
                Colors.purple,
                Color(0xFF7A9E8E),
              ],
            ),
          ),

          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      children: [
                        // Receipt Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 25,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Success Icon
                              Container(
                                height: 95,
                                width: 95,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(
                                    0xFFDDEBE3,
                                  ).withOpacity(0.8),
                                ),
                                child: const Icon(
                                  Icons.check_circle_rounded,
                                  size: 60,
                                  color: Color(0xFF7A9E8E),
                                ),
                              ),

                              const SizedBox(height: 24),

                              const Text(
                                "Payment Successful!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),

                              const SizedBox(height: 12),

                              const Text(
                                "Your order has been placed successfully.\nThank you for shopping with us.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 15,
                                  height: 1.6,
                                  color: AppColors.textSecondary,
                                ),
                              ),

                              const SizedBox(height: 30),

                              // Dashed Divider
                              Row(
                                children: List.generate(
                                  24,
                                  (index) => Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
                                      height: 1,
                                      color: index.isEven
                                          ? Colors.grey.shade300
                                          : Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 25),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Order ID",
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 15,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    "#$displayOrderId",
                                    style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Status",
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 15,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    "Confirmed",
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Back Home Button
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MainShellScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF556B7B),
                              elevation: 6,
                              shadowColor: const Color(
                                0xFF556B7B,
                              ).withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.home_rounded, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  "Back to Home",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "We hope your baby loves our products ❤️",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
