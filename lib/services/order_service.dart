import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Place Order to Firestore ────────────────────────────────────
  static Future<Map<String, dynamic>> placeOrder({
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double discount,
    required double total,
    required String fullName,
    required String address,
    required String city,
    required String paymentMethod,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return {'error': 'User not logged in'};

      // Create the order document in user's sub-collection
      final orderRef = _db
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .doc();
      final orderId = orderRef.id;

      final orderData = {
        'orderId': orderId,
        'userId': user.uid,
        'userEmail': user.email,
        'fullName': fullName,
        'shippingAddress': {'address': address, 'city': city},
        'items': items,
        'subtotal': subtotal,
        'discount': discount,
        'total': total,
        'paymentMethod': paymentMethod,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Save to user's orders sub-collection
      await orderRef.set(orderData);

      // Also save to a top-level 'orders' collection for admin visibility (optional but recommended)
      await _db.collection('orders').doc(orderId).set(orderData);

      // Increment ordersCount in user document
      await _db.collection('users').doc(user.uid).update({
        'ordersCount': FieldValue.increment(1),
      });

      return {'orderId': orderId}; // Success
    } catch (e) {
      print('Error placing order: $e');
      return {'error': e.toString()};
    }
  }

  // ── Get User Orders ─────────────────────────────────────────────
  static Stream<QuerySnapshot> getUserOrders() {
    return _auth.authStateChanges().asyncExpand((user) {
      if (user == null) return const Stream.empty();

      return _db
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .snapshots();
    });
  }
}
