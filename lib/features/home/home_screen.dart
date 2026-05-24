import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

import 'home_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the basic structural layout for a screen
    return Scaffold(
      // SafeArea prevents your UI from overlapping with the phone's status bar or notch
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: const [TopBanner()],
        ),

        // child: Center(
        //   child: Text(
        //     'Baby Store Home',
        //     style: TextStyle(
        //       fontSize: 24,
        //       fontFamily: 'Poppins',
        //       fontWeight: FontWeight.bold,
        //       color: AppColors.textPrimary,
        //     ),
        //   ),
        // ),
      ),
      // A standard bottom navigation bar to match your Figma's footer
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: AppColors.cream,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Registry',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
