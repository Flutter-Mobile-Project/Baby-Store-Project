import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../theme/app_colors.dart';
import '../../../services/review_service.dart';

class ProductReviewSection extends StatefulWidget {
  final String productId;

  const ProductReviewSection({super.key, required this.productId});

  @override
  State<ProductReviewSection> createState() => _ProductReviewSectionState();
}

class _ProductReviewSectionState extends State<ProductReviewSection> {
  final TextEditingController _reviewController = TextEditingController();
  int _selectedRating = 0;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a star rating first! ⭐'), backgroundColor: Colors.orange, behavior: SnackBarBehavior.floating),
      );
      return;
    }

    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a comment first! ✍️'), backgroundColor: Colors.orange, behavior: SnackBarBehavior.floating),
      );
      return;
    }

    // Send data to Firebase
    await ReviewService.addReview(
      productId: widget.productId,
      rating: _selectedRating,
      text: _reviewController.text,
    );

    setState(() {
      _selectedRating = 0;
      _reviewController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review saved successfully! ❤️'), backgroundColor: AppColors.mint, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Reviews',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),

        // 1. RATING SUMMARY
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const Text(
                  '4.8',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 48, fontWeight: FontWeight.bold, height: 1),
                ),
                Row(
                  children: const [
                    Icon(Icons.star, color: Color(0xFFFFD700), size: 16),
                    Icon(Icons.star, color: Color(0xFFFFD700), size: 16),
                    Icon(Icons.star, color: Color(0xFFFFD700), size: 16),
                    Icon(Icons.star, color: Color(0xFFFFD700), size: 16),
                    Icon(Icons.star_half, color: Color(0xFFFFD700), size: 16),
                  ],
                ),
                const SizedBox(height: 4),
                
                // ✅ DYNAMIC COUNTER: Starts at 124, adds new reviews automatically!
                StreamBuilder<QuerySnapshot>(
                  stream: ReviewService.getReviewsStream(widget.productId),
                  builder: (context, snapshot) {
                    int totalReviews = 124; // Keep the base number high so it looks real
                    if (snapshot.hasData) {
                      totalReviews += snapshot.data!.docs.length; // Add new Firebase reviews
                    }
                    return Text(
                      '$totalReviews reviews',
                      style: TextStyle(fontFamily: 'Nunito', fontSize: 12, color: Colors.grey.shade500),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(width: 32),
            Expanded(
              child: Column(
                children: [
                  _buildRatingBar('5 ★', 0.85),
                  _buildRatingBar('4 ★', 0.10),
                  _buildRatingBar('3 ★', 0.03),
                  _buildRatingBar('2 ★', 0.01),
                  _buildRatingBar('1 ★', 0.01),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // 2. WRITE A REVIEW FORM
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade200)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Share your feedback', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRating = index + 1),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Icon(index < _selectedRating ? Icons.star : Icons.star_border, color: const Color(0xFFFFD700), size: 28),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Would you like to write something about this product?',
                  hintStyle: TextStyle(fontFamily: 'Nunito', fontSize: 13, color: Colors.grey.shade400),
                  filled: true,
                  fillColor: AppColors.cream,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C7282),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 0,
                  ),
                  onPressed: _handleSubmit,
                  child: const Text('Submit', style: TextStyle(fontFamily: 'Nunito', fontSize: 12, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // 3. HYBRID REVIEWS (Real Firebase ones + Fake presentation ones)
        StreamBuilder<QuerySnapshot>(
          stream: ReviewService.getReviewsStream(widget.productId),
          builder: (context, snapshot) {
            List<Widget> realReviewsWidgets = [];

            // If Firebase has data, create widgets for them
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              realReviewsWidgets = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    _buildReviewItem(
                      data['name'] ?? 'Guest User',
                      data['badge'] ?? 'Verified Buyer',
                      'Just now', 
                      data['rating'] ?? 5,
                      data['text'] ?? '',
                    ),
                    const Divider(color: Color(0xFFEEEEEE), height: 24),
                  ],
                );
              }).toList();
            }

            // Return Firebase reviews FIRST, then the fake ones SECOND so UI is always full!
            return Column(
              children: [
                ...realReviewsWidgets, 
                // We keep these so your UI never looks empty during the presentation!
                _buildReviewItem(
                  'Sophia M.',
                  'Verified Buyer',
                  '2 days ago',
                  5,
                  'Absolutely love the premium material! It feels incredibly safe and smooth for my baby.',
                ),
                const Divider(color: Color(0xFFEEEEEE), height: 24),
                _buildReviewItem(
                  'Liam K.',
                  'Verified Buyer',
                  '1 week ago',
                  4,
                  'Very soft and matches the photo perfectly. Delivery took an extra day but product is top notch.',
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildRatingBar(String label, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: percentage, backgroundColor: Colors.grey.shade200, color: const Color(0xFFFFD700), minHeight: 6))),
        ],
      ),
    );
  }

  // ✅ MAGIC FIX HERE: Generates a beautiful random color based on the user's name!
  Widget _buildReviewItem(String name, String badge, String date, int rating, String text) {
    
    // Create a list of soft, pretty colors matching your app's theme
    final List<Color> avatarColors = [
      AppColors.babyBlue,
      AppColors.babyPink,
      AppColors.mint,
      Colors.orange.shade200,
      Colors.purple.shade200,
      Colors.teal.shade200,
    ];

    // Pick a color mathematically based on their name so "Sophia" is always the same color
    final int colorIndex = name.hashCode.abs() % avatarColors.length;
    final Color userColor = avatarColors[colorIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: userColor, // Uses the dynamic color
                  radius: 14, 
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?', // Capitalizes the first letter
                    style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)
                  )
                ),
                const SizedBox(width: 8),
                Text(name, style: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
                  child: Text(badge, style: TextStyle(fontFamily: 'Nunito', color: Colors.green.shade700, fontSize: 8, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Text(date, style: TextStyle(fontFamily: 'Nunito', color: Colors.grey.shade400, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 6),
        Row(children: List.generate(5, (i) => Icon(i < rating ? Icons.star : Icons.star_border, color: const Color(0xFFFFD700), size: 14))),
        const SizedBox(height: 6),
        Text(text, style: const TextStyle(fontFamily: 'Nunito', fontSize: 13, color: AppColors.textPrimary, height: 1.4)),
      ],
    );
  }
}