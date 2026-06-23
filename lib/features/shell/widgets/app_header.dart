import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final int cartItemCount;
  final VoidCallback onCartPressed;
  final VoidCallback onSearchPressed;
  final VoidCallback onMenuPressed;

  const AppHeader({
    super.key,
    required this.cartItemCount,
    required this.onCartPressed,
    required this.onSearchPressed,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.cream,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.textPrimary),
        onPressed: onMenuPressed,
      ),
      title: const Text(
        'TinyTots',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        IconButton(
          icon: Badge(
            label: Text('$cartItemCount'),
            isLabelVisible: cartItemCount > 0,
            backgroundColor: Colors.redAccent,
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.textPrimary,
            ),
          ),
          onPressed: onCartPressed,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
