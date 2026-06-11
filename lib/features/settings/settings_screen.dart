import 'package:baby_store_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baby_store_app/theme/app_colors.dart';
import 'package:baby_store_app/state/user_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final VoidCallback? onLogout;
  final VoidCallback? onOrderHistoryTap;

  const SettingsScreen({super.key, this.onLogout, this.onOrderHistoryTap});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final bool canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Profile header ─────────────────────────────────
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/profile/image1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.2),
                          AppColors.cream,
                        ],
                      ),
                    ),
                  ),
                ),
                if (canPop)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.7),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: AppColors.textPrimary,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                Positioned(
                  top: 60,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 26),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 46,
                              backgroundImage: user?.avatar != null
                                  ? NetworkImage(user!.avatar!)
                                  : const AssetImage(
                                          'assets/images/profile/image2.png',
                                        )
                                        as ImageProvider,
                            ),
                          ),
                          if (user != null)
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF7A7570),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user?.name ?? 'Guest User',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.badgeBlue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          user?.membership ?? 'Standard Member',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2B6CB0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Stats ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      '${user?.ordersCount ?? 0}',
                      'Orders',
                      onTap: widget.onOrderHistoryTap,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard('${user?.points ?? 0}', 'Points'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('1', 'Registry')),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Account Essentials'),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      children: [
                        // In _settingsItem for My Orders — add onTap:
                        _settingsItem(
                          icon: Icons.layers_outlined,
                          iconBg: AppColors.mint,
                          iconColor: const Color(0xFF3182CE),
                          title: 'My Orders',
                          onTap: widget.onOrderHistoryTap,
                        ),
                        _divider(),
                        _settingsItem(
                          icon: Icons.credit_card,
                          iconBg: AppColors.babyPink,
                          iconColor: const Color(0xFFB83280),
                          title: 'Payment Methods',
                        ),
                        _divider(),
                        _settingsItem(
                          icon: Icons.location_on_outlined,
                          iconBg: AppColors.mintLight,
                          iconColor: const Color(0xFF2F855A),
                          title: 'Shipping Addresses',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  _sectionTitle('My Little One'),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      children: [
                        _settingsItem(
                          icon: Icons.chair_alt_outlined,
                          iconBg: AppColors.badgeBlue,
                          iconColor: const Color(0xFF2B6CB0),
                          title: 'Nursery Registry',
                          trailingText: '8 items',
                        ),
                        _divider(),
                        _settingsItem(
                          icon: Icons.face_outlined,
                          iconBg: AppColors.babyPink,
                          iconColor: const Color(0xFFB83280),
                          title: user?.babyName ?? "Baby's Profile",
                          subtitle: _calculateBabyAge(user?.babyBirthday),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  _settingsSupportItem(Icons.help_outline, 'Help Center'),
                  _settingsSupportItem(Icons.shield_outlined, 'Privacy Policy'),

                  const SizedBox(height: 30),

                  // ── Sign out ──────────────────────────────────
                  if (user != null)
                    GestureDetector(
                      onTap: () async {
                        // Confirm logout
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Sign Out'),
                            content: const Text(
                              'Are you sure you want to sign out?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text(
                                  'Sign Out',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          setState(() => _isLoggingOut = true);
                          try {
                            await AuthService.logout();
                            ref.read(userProvider.notifier).state = null;

                            if (!mounted) return;

                            // Force a full app reset by navigating to the root and clearing the stack
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pushNamedAndRemoveUntil('/', (route) => false);
                          } finally {
                            if (mounted) setState(() => _isLoggingOut = false);
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.logoutBg,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: _isLoggingOut
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.logoutText,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.logout,
                                    color: AppColors.logoutText,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Sign Out',
                                    style: TextStyle(
                                      color: AppColors.logoutText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateBabyAge(String? birthdayStr) {
    if (birthdayStr == null) return 'Add your baby info';
    try {
      final birthday = DateTime.parse(birthdayStr);
      final now = DateTime.now();
      final difference = now.difference(birthday);

      if (difference.inDays < 30) {
        return '${difference.inDays} days old';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return '$months months old';
      } else {
        final years = (difference.inDays / 365).floor();
        return '$years years old';
      }
    } catch (e) {
      return 'Baby Profile';
    }
  }

  Widget _buildStatCard(String count, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.beige,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.6), width: 1),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 64),
      child: Divider(height: 1, color: Colors.grey.withOpacity(0.15)),
    );
  }

  Widget _settingsItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    String? subtitle,
    String? trailingText,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: iconBg,
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailingText != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  trailingText,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsSupportItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.textPrimary.withOpacity(0.8)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
