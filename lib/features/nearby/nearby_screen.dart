import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baby_store_app/theme/app_colors.dart';
import 'package:baby_store_app/widgets/feature_store_card.dart';
import 'package:baby_store_app/data/mock_repository.dart';
import 'package:baby_store_app/models/branch.dart';
import 'package:baby_store_app/state/store_provider.dart';
import '../shell/main_shell_screen.dart';

class NearbyScreen extends ConsumerStatefulWidget {
  final void Function(int)? onNavigate;
  const NearbyScreen({super.key, this.onNavigate});

  @override
  ConsumerState<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends ConsumerState<NearbyScreen> {
  late Future<List<Branch>> _branchesFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _branchesFuture = MockRepository().loadBranches();
  }

  Future<void> _refresh() async {
    setState(() {
      _branchesFuture = MockRepository().loadBranches();
    });
  }

  void _showBranchDetails(BuildContext context, Branch branch) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              branch.name,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    branch.address,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.access_time_outlined,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Mon–Sat: 8AM – 8PM  |  Sun: 10AM – 6PM',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // ── Bottom Sheet: View on Map ──────────────────
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Close bottom sheet

                      // ✅ FIX: Use 'this.ref' to bypass the local context and target Riverpod
                      this.ref
                          .read(storeProvider.notifier)
                          .selectBranch(branch);

                      widget.onNavigate?.call(tabMap);
                    },
                    icon: const Icon(Icons.map_outlined, size: 16),
                    label: const Text(
                      'View on Map',
                      style: TextStyle(fontFamily: 'Nunito'),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // ── Bottom Sheet: Directions Button ────────────
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Close bottom sheet

                      // ✅ FIX: Use 'this.ref' here as well to cleanly specify global state
                      this.ref
                          .read(storeProvider.notifier)
                          .selectBranch(branch);

                      widget.onNavigate?.call(tabMap);
                    },
                    icon: const Icon(Icons.directions_outlined, size: 16),
                    label: const Text(
                      'Directions',
                      style: TextStyle(fontFamily: 'Nunito'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textPrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Branch>>(
      future: _branchesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Failed to load stores',
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 15),
                ),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: _refresh, child: const Text('Retry')),
              ],
            ),
          );
        }

        final allBranches = snapshot.data!;

        final branches = _searchQuery.isEmpty
            ? allBranches
            : allBranches
                  .where(
                    (b) =>
                        b.name.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ||
                        b.address.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ),
                  )
                  .toList();

        return RefreshIndicator(
          onRefresh: _refresh,
          color: AppColors.textPrimary,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 8),
              const Text(
                'Nearby Stores',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${branches.length} store${branches.length != 1 ? 's' : ''} near you',
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search, color: AppColors.textSecondary),
                    hintText: 'Search for nearby stores...',
                    hintStyle: TextStyle(
                      fontFamily: 'Nunito',
                      color: AppColors.textSecondary,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => widget.onNavigate?.call(tabMap),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_outlined, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'View All on Map',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (branches.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.store_mall_directory_outlined,
                          size: 48,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No stores found for "$_searchQuery"',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...branches.map(
                  (branch) => FeaturedStoreCard(
                    image: branch.image,
                    name: branch.name,
                    address: branch.address,
                    rating: branch.rating,
                    stockText: branch.stockText,
                    onDirections: () {
                      ref.read(storeProvider.notifier).selectBranch(branch);
                      widget.onNavigate?.call(tabMap);
                    },
                    onDetails: () => _showBranchDetails(context, branch),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
