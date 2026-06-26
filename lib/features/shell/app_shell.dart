import 'package:flutter/material.dart';
import 'package:baby_store_app/features/home/widgets/homeSidebar.dart';
import 'package:baby_store_app/features/shell/widgets/app_header.dart';
import 'package:baby_store_app/features/shell/widgets/app_footer.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final int cartItemCount;
  final int favoritesCount;
  final void Function(int) onDestinationSelected;
  final void Function(int)? onNavigate;
  final VoidCallback? onCartPressed;
  final VoidCallback? onSearchPressed;

  const AppShell({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.cartItemCount,
    required this.favoritesCount,
    required this.onDestinationSelected,
    this.onNavigate,
    this.onCartPressed,
    this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── Sidebar ───────────────────────────────────────────────
      drawer: HomeDrawer(onNavigate: onNavigate),

      // ── Header ────────────────────────────────────────────────
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Builder(
          builder: (ctx) => AppHeader(
            cartItemCount: cartItemCount,
            onCartPressed: onCartPressed ?? () {},
            onSearchPressed: onSearchPressed ?? () {},
            onMenuPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),

      // ── Content ───────────────────────────────────────────────
      body: child,

      // ── Footer ────────────────────────────────────────────────
      bottomNavigationBar: AppFooter(
        selectedIndex: selectedIndex,
        favoritesCount: favoritesCount,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
