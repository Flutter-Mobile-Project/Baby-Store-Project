import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Create Booking in Firestore ─────────────────────────────────
  static Future<String?> createBooking({
    required String specialistName,
    required String specialistRole,
    required DateTime date,
    required String time,
    required String clientName,
    required String clientPhone,
    required String clientNote,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return 'User not logged in';

      final bookingRef = _db.collection('bookings').doc();

      final bookingData = {
        'bookingId': bookingRef.id,
        'userId': user.uid,
        'userEmail': user.email,
        'specialistName': specialistName,
        'specialistRole': specialistRole,
        'date': Timestamp.fromDate(date),
        'time': time,
        'clientName': clientName,
        'clientPhone': clientPhone,
        'clientNote': clientNote,
        'status': 'Confirmed',
        'createdAt': FieldValue.serverTimestamp(),
      };

      // 1. Save to global bookings collection
      await bookingRef.set(bookingData);

      // 2. Save to user-specific bookings sub-collection
      await _db.collection('users').doc(user.uid).collection('bookings').doc(bookingRef.id).set(bookingData);

      return null; // Success
    } catch (e) {
      print('Error creating booking: $e');
      return e.toString();
    }
  }

  // ── Get User Bookings ───────────────────────────────────────────
  static Stream<QuerySnapshot> getUserBookings() {
    return _auth.authStateChanges().asyncExpand((user) {
      if (user == null) {
        return const Stream.empty();
      }

      // Query the user's 'bookings' sub-collection
      return _db.collection('users')
          .doc(user.uid)
          .collection('bookings')
          .orderBy('date', descending: true)
          .snapshots();
    });
  }
}
