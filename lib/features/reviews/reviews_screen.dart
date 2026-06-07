import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample review data to populate the list view
    final List<Map<String, dynamic>> reviews = [
      {
        'name': 'Sophia Laurent',
        'rating': 5,
        'date': '2 days ago',
        'comment':
            'Absolutely love this sleepsuit! The organic cotton feels incredibly soft on my baby’s skin. It washed beautifully without stretching or losing its color.',
        'avatarColor': AppColors.babyPink,
      },
      {
        'name': 'Liam Harrison',
        'rating': 4,
        'date': '1 week ago',
        'comment':
            'Great quality material. The double zipper makes midnight diaper changes so much easier. Dropped one star only because shipping took a bit longer than expected.',
        'avatarColor': AppColors.babyBlue,
      },
      {
        'name': 'Emma Watson',
        'rating': 5,
        'date': '2 weeks ago',
        'comment':
            'Perfect fit for my 4-month-old. The mint color looks exactly like the photos. Will definitely be buying a couple more of these!',
        'avatarColor': AppColors.mint,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.cream, // Matches your main global background
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
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '4.8',
                      style: TextStyle(
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
                          index < 4 ? Icons.star : Icons.star_half,
                          color: const Color(0xFFFFD700),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '124 Verified Buyer\nReviews & Ratings',
                  textAlign: Alignment.right,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // ── 2. SCROLLING REVIEWS LIST ────────────────────────────
          Expanded(
            child: ListView.separated(
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
                            backgroundColor: review['avatarColor'],
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
            ),
          ),
        ],
      ),
    );
  }
}
