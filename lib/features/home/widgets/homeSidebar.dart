import 'package:flutter/material.dart';
import 'package:baby_store_app/theme/app_colors.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      // We use a Column so we can precisely control the layout
      child: SafeArea(
        child: Column(
          children: [
            // --- 1. THE HEADER ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  // The light blue circle with the user icon
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.babyBlue,
                    child: const Icon(
                      Icons.person_outline,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // The User Text
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, Parent',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Platinum Member',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // The subtle dividing line
            const Divider(color: Color(0xFFEEEEEE), height: 1, thickness: 1),
            
            const SizedBox(height: 16),

            // --- 2. THE MENU ITEMS ---
            _buildDrawerItem(Icons.location_on_outlined, 'Nearby Stores'),
            _buildDrawerItem(Icons.local_offer_outlined, 'Coupons'),
            _buildDrawerItem(Icons.calendar_today_outlined, 'Service Booking'),
            _buildDrawerItem(Icons.support_agent_outlined, 'Support Chat'),
          ],
        ),
      ),
    );
  }

  // --- HELPER METHOD ---
  // Makes creating the list items fast and identical
  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      // This is where you would add navigation logic later
      onTap: () {}, 
    );
  }
}