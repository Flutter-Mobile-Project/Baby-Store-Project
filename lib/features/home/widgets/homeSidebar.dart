import 'package:baby_store_app/features/shell/main_shell_screen.dart';
import 'package:baby_store_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baby_store_app/state/user_provider.dart';

class HomeDrawer extends ConsumerWidget {
 
  final void Function(int tabIndex)? onNavigate;

  const HomeDrawer({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Scaffold.of(context).closeDrawer();
                onNavigate?.call(tabProfile); // ← switch to Profile tab
              },
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.babyBlue,
                      backgroundImage: user?.avatar != null
                          ? NetworkImage(user!.avatar!)
                          : null,
                      child: user?.avatar == null
                          ? const Icon(
                              Icons.person_outline,
                              color: AppColors.textPrimary,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user != null
                                ? 'Hello, ${user.name}'
                                : 'Hello, Guest',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.membership ?? 'Register to unlock benefits',
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(color: Color(0xFFEEEEEE), height: 1),
            const SizedBox(height: 16),

            _buildDrawerItem(
              context,
              Icons.location_on_outlined,
              'Nearby Stores',
              tabNearby,
            ),
            _buildDrawerItem(
              context,
              Icons.local_offer_outlined,
              'Coupons',
              tabPromotions,
            ),
            _buildDrawerItem(
              context,
              Icons.calendar_today_outlined,
              'Service Booking',
              tabBooking,
            ),
            _buildDrawerItem(
              context,
              Icons.support_agent_outlined,
              'Support Chat',
              tabChat,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String label,
    int tabIndex,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        Scaffold.of(context).closeDrawer();
        onNavigate?.call(tabIndex); // ← switch tab, never push a route
      },
    );
  }
}
