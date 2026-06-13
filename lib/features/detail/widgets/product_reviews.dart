import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class ProductReviewSection extends StatefulWidget {
  // ✅ This function lets us send the data back to the main screen!
  final Function(int rating, String comment)? onSubmitReview;

  const ProductReviewSection({super.key, this.onSubmitReview});

  @override
  State<ProductReviewSection> createState() => _ProductReviewSectionState();
}

class _ProductReviewSectionState extends State<ProductReviewSection> {
  // ✅ These variables give the form a "memory"
  final TextEditingController _reviewController = TextEditingController();
  int _selectedRating = 0; // 0 means no stars selected yet

  @override
  void dispose() {
    _reviewController.dispose(); // Always clean up controllers!
    super.dispose();
  }

  void _handleSubmit() {
    if (_selectedRating == 0) {
      // Don't let them submit without a star rating!
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a star rating first! ⭐'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 1. If we passed a function from the main screen, send the data to it!
    if (widget.onSubmitReview != null) {
      widget.onSubmitReview!(_selectedRating, _reviewController.text);
    } else {
      // Print it to the console just so you can see it working!
      print(
        '🌟 REVIEW SUBMITTED! Rating: $_selectedRating | Comment: ${_reviewController.text}',
      );
    }

    // 2. Clear the form so it looks clean again
    setState(() {
      _selectedRating = 0;
      _reviewController.clear();
    });

    // 3. Show the success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for your feedback! ❤️'),
        backgroundColor: AppColors.mint,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Reviews',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        // 1. RATING SUMMARY BREAKDOWN
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const Text(
                  '4.8',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                Row(
                  children: List.generate(
                    5,
                    (i) => const Icon(
                      Icons.star,
                      color: Color(0xFFFFD700),
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '124 reviews',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
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

        // 2. SMART "WRITE A REVIEW" FORM
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Share your feedback',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // ✅ Make the stars actually clickable!
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRating =
                            index + 1; // index is 0-4, rating is 1-5
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Icon(
                        index < _selectedRating
                            ? Icons.star
                            : Icons.star_border,
                        color: const Color(0xFFFFD700), // Gold color
                        size: 28,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),

              // ✅ Connect the TextField to the controller!
              TextField(
                controller: _reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText:
                      'Would you like to write something about this product?',
                  hintStyle: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 13,
                    color: Colors.grey.shade400,
                  ),
                  filled: true,
                  fillColor: AppColors.cream,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C7282),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 0,
                  ),
                  onPressed: _handleSubmit, // ✅ Call our new smart function!
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // 3. EXISTING CUSTOMER REVIEWS
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
  }

  Widget _buildRatingBar(String label, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
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
        ],
      ),
    );
  }

  Widget _buildReviewItem(
    String name,
    String badge,
    String date,
    int rating,
    String text,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.babyBlue,
                  radius: 14,
                  child: Text(
                    name[0],
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.green.shade700,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              date,
              style: TextStyle(
                fontFamily: 'Nunito',
                color: Colors.grey.shade400,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: List.generate(
            5,
            (i) => Icon(
              i < rating ? Icons.star : Icons.star_border,
              color: const Color(0xFFFFD700),
              size: 14,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 13,
            color: AppColors.textPrimary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
