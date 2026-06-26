import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_store_app/services/auth_service.dart';

class ReviewService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. ADD a review to a specific product
  static Future<void> addReview({
    required String productId,
    required int rating,
    required String text,
  }) async {
    try {
      String userName = AuthService.userName ?? 'Guest User';

      // We save reviews INSIDE a specific product's folder
      await _db.collection('products').doc(productId).collection('reviews').add({
        'rating': rating,
        'text': text,
        'name': userName,
        'badge': 'Verified Buyer',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving review: $e");
    }
  }

  // 2. LISTEN to reviews for a specific product LIVE
  static Stream<QuerySnapshot> getReviewsStream(String productId) {
    return _db
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}