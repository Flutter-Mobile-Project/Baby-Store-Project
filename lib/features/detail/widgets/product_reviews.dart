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
        StreamBuilder<QuerySnapshot>(
          stream: ReviewService.getReviewsStream(widget.productId),
          builder: (context, snapshot) {
            int totalReviews = 0;
            double avgRating = 0.0;
            Map<int, int> ratingDistribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
            
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              totalReviews = snapshot.data!.docs.length;
              final ratings = snapshot.data!.docs
                  .map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final rating = data['rating'] ?? 0;
                    if (rating >= 1 && rating <= 5) {
                      ratingDistribution[rating] = (ratingDistribution[rating] ?? 0) + 1;
                    }
                    return rating;
                  })
                  .toList();
              avgRating = ratings.isNotEmpty ? ratings.reduce((a, b) => a + b) / ratings.length : 0.0;
            }
            
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      avgRating > 0 ? avgRating.toStringAsFixed(1) : '0.0',
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 48, fontWeight: FontWeight.bold, height: 1),
                    ),
                    Row(
                      children: List.generate(5, (index) => Icon(
                        index < avgRating ? Icons.star : Icons.star_border,
                        color: const Color(0xFFFFD700),
                        size: 16,
                      )),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalReviews reviews',
                      style: TextStyle(fontFamily: 'Nunito', fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    children: [
                      if (totalReviews > 0)
                        ...List.generate(5, (starRating) {
                          final count = ratingDistribution[5 - starRating] ?? 0;
                          final percentage = totalReviews > 0 ? (count / totalReviews) : 0.0;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                Text(
                                  '${5 - starRating}',
                                  style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.star, color: Color(0xFFFFD700), size: 12),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: percentage,
                                      backgroundColor: Colors.grey.shade200,
                                      color: const Color(0xFFFFD700),
                                      minHeight: 6,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$count',
                                  style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ],
            );
          },
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

        // 3. REAL REVIEWS ONLY
        StreamBuilder<QuerySnapshot>(
          stream: ReviewService.getReviewsStream(widget.productId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading reviews'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'No reviews yet. Be the first to review!',
                    style: TextStyle(fontFamily: 'Nunito', fontSize: 14, color: Colors.grey),
                  ),
                ),
              );
            }
            
            final reviews = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return {
                'name': data['name'] ?? 'Anonymous',
                'rating': data['rating'] ?? 0,
                'date': _formatDate(data['createdAt']),
                'text': data['text'] ?? '',
              };
            }).toList();
            
            return Column(
              children: [
                ...reviews.asMap().entries.map((entry) {
                  final index = entry.key;
                  final review = entry.value;
                  return Column(
                    children: [
                      _buildReviewItem(
                        review['name'],
                        'Verified Buyer',
                        review['date'],
                        review['rating'],
                        review['text'],
                      ),
                      if (index < reviews.length - 1)
                        const Divider(color: Color(0xFFEEEEEE), height: 24),
                    ],
                  );
                }).toList(),
              ],
            );
          },
        ),
      ],
    );
  }

  static String _formatDate(dynamic createdAt) {
    if (createdAt == null) return 'Recently';
    try {
      final date = createdAt is Timestamp ? createdAt.toDate() : DateTime.parse(createdAt.toString());
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inDays > 7) return '${diff.inDays ~/ 7} weeks ago';
      if (diff.inDays > 0) return '${diff.inDays} days ago';
      if (diff.inHours > 0) return '${diff.inHours} hours ago';
      return 'Recently';
    } catch (e) {
      return 'Recently';
    }
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