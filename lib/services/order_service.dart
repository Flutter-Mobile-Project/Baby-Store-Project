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

      // Create the order document
      final orderRef = _db.collection('orders').doc();
      final orderId = orderRef.id;
      
      await orderRef.set({
        'orderId': orderId,
        'userId': user.uid,
        'userEmail': user.email,
        'fullName': fullName,
        'shippingAddress': {
          'address': address,
          'city': city,
        },
        'items': items,
        'subtotal': subtotal,
        'discount': discount,
        'total': total,
        'paymentMethod': paymentMethod,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Also add to a user-specific sub-collection for easy lookup
      await _db.collection('users').doc(user.uid).collection('my_orders').doc(orderId).set({
        'orderId': orderId,
        'total': total,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

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
    // We use authStateChanges to ensure that if the user state isn't ready yet,
    // the stream will update once the user is authenticated.
    return _auth.authStateChanges().asyncExpand((user) {
      if (user == null) {
        return const Stream.empty();
      }

      // Query the top-level 'orders' collection for this user.
      // NOTE: This query REQUIRES a composite index in Firestore:
      // Collection: orders, Fields: userId (Ascending), createdAt (Descending)
      return _db.collection('orders')
          .where('userId', isEqualTo: user.uid)
          .snapshots();
    });
  }
}
