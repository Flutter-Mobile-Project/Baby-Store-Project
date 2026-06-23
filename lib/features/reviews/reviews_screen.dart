import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/app_colors.dart';
import '../../services/review_service.dart';

class ReviewsScreen extends StatelessWidget {
  final String productId;

  const ReviewsScreen({super.key, this.productId = 'Organic Cotton Sleepsuit'});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Customer Reviews',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── 1. RATING SUMMARY HEADER CARD ────────────────────────
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.beige, // Accent frame background
              borderRadius: BorderRadius.circular(24),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: ReviewService.getReviewsStream(productId),
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
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              avgRating > 0 ? avgRating.toStringAsFixed(1) : '0.0',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Text(
                              'out of 5 stars',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  index < avgRating ? Icons.star : Icons.star_border,
                                  color: const Color(0xFFFFD700),
                                  size: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$totalReviews Verified Buyer Reviews',
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        if (totalReviews > 0)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ...List.generate(5, (starRating) {
                                final count = ratingDistribution[5 - starRating] ?? 0;
                                final percentage = totalReviews > 0 ? (count / totalReviews) : 0.0;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${5 - starRating}',
                                        style: const TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.star, color: Color(0xFFFFD700), size: 12),
                                      const SizedBox(width: 4),
                                      Container(
                                        width: 100,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: FractionallySizedBox(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: percentage,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFD700),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '$count',
                                        style: const TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          // ── 2. SCROLLING REVIEWS LIST ────────────────────────────
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ReviewService.getReviewsStream(productId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading reviews'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No reviews yet. Be the first to review!',
                      style: TextStyle(fontFamily: 'Nunito', fontSize: 16),
                    ),
                  );
                }
                final reviews = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return {
                    'name': data['name'] ?? 'Anonymous',
                    'rating': data['rating'] ?? 0,
                    'date': _formatDate(data['createdAt']),
                    'comment': data['text'] ?? '',
                  };
                }).toList();
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  itemCount: reviews.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.babyPink,
                                radius: 20,
                                child: Text(
                                  review['name'][0],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review['name'],
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (starIndex) => Icon(
                                          Icons.star,
                                          color: starIndex < review['rating']
                                              ? const Color(0xFFFFD700)
                                              : Colors.grey.shade300,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                review['date'],
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            review['comment'],
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}