import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // ── Firebase Instance ───────────────────────────────────────────
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ── In-memory fast access ───────────────────────────────────────
  static bool isRegistered = false;
  static String? _userName;
  static String? _userEmail;

  // ── Keys ────────────────────────────────────────────────────────
  static const String _keyRegistered = 'auth_is_registered';
  static const String _keyUserName = 'auth_user_name';
  static const String _keyUserEmail = 'auth_user_email';

  // ── Save User Data to Firestore ─────────────────────────────────
  static Future<void> saveUserData({
    required String uid,
    required String name,
    required String email,
    String? avatar,
    String? birthday,
  }) async {
    await _db.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'avatar': avatar,
      'birthday': birthday,
      'membership': 'Platinum Member',
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ── Google Sign In ──────────────────────────────────────────────
  static Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // ✅ Save to Firestore
        await saveUserData(
          uid: user.uid,
          name: user.displayName ?? 'Google User',
          email: user.email ?? '',
          avatar: user.photoURL,
        );

        // Save to SharedPreferences
        await register(
          name: user.displayName ?? 'Google User',
          email: user.email ?? '',
        );
      }

      return user;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  // ── Save on register ────────────────────────────────────────────
  static Future<void> register({
    required String name,
    required String email,
  }) async {
    // Update in-memory
    isRegistered = true;
    _userName = name;
    _userEmail = email;

    // Persist to device storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRegistered, true);
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserEmail, email);
  }

  // ── Clear on logout ─────────────────────────────────────────────
  static Future<void> logout() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print('Error during Firebase logout: $e');
    }

    // Always clear local state even if Firebase fails
    isRegistered = false;
    _userName = null;
    _userEmail = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRegistered);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
  }

  // ── Load on app start ───────────────────────────────────────────
  static Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    isRegistered = prefs.getBool(_keyRegistered) ?? false;
    _userName = prefs.getString(_keyUserName);
    _userEmail = prefs.getString(_keyUserEmail);
  }

  static String? get userName => _userName;
  static String? get userEmail => _userEmail;
}
