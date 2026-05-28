import 'package:flutter/material.dart';
import 'package:baby_store_app/theme/app_colors.dart';
import 'package:baby_store_app/widgets/feature_store_card.dart';
import 'package:baby_store_app/data/mock_repository.dart';
import 'package:baby_store_app/models/branch.dart';

class NearbyScreen extends StatelessWidget {
  const NearbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        title: const Text(
          'TinyTots',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder<List<Branch>>(
        future: MockRepository().loadBranches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load stores'));
          }

          final branches = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 🔍 Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: 'Search for nearby stores...',
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🏬 Stores from JSON
              ...branches.map(
                (branch) => FeaturedStoreCard(
                  image: branch.image,
                  name: branch.name,
                  address: branch.address,
                  rating: branch.rating,
                  stockText: branch.stockText,
                  onDirections: () {
                    Navigator.pushNamed(context, '/map');
                  },
                  onDetails: () {},
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
