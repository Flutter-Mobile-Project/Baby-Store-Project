import 'package:flutter/material.dart';
import 'package:baby_store_app/theme/app_colors.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.babyBlue,
                    child: const Icon(
                      Icons.person_outline,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
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

            const Divider(color: Color(0xFFEEEEEE), height: 1),
            const SizedBox(height: 16),

            _buildDrawerItem(
              context,
              Icons.location_on_outlined,
              'Nearby Stores',
              '/nearby',
            ),
            _buildDrawerItem(
              context,
              Icons.local_offer_outlined,
              'Coupons',
              '/promotions',
            ),
            _buildDrawerItem(
              context,
              Icons.calendar_today_outlined,
              'Service Booking',
              '/booking',
            ),
            _buildDrawerItem(
              context,
              Icons.support_agent_outlined,
              'Support Chat',
              '/chat',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
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
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}
