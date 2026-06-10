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
      await _db.collection('users').doc(user.uid).collection('my_bookings').doc(bookingRef.id).set({
        'bookingId': bookingRef.id,
        'specialistName': specialistName,
        'date': Timestamp.fromDate(date),
        'time': time,
        'status': 'Confirmed',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null; // Success
    } catch (e) {
      print('Error creating booking: $e');
      return e.toString();
    }
  }

  // ── Get User Bookings ───────────────────────────────────────────
  static Stream<QuerySnapshot> getUserBookings() {
    final User? user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _db.collection('bookings')
        .where('userId', isEqualTo: user.uid)
        .orderBy('date', descending: true)
        .snapshots();
  }
}
