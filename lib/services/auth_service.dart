import 'package:baby_store_app/models/user.dart' as model;
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

  // ── Get User Profile from Firestore ─────────────────────────────
  static Future<model.User?> getUserProfile(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return model.User.fromFirestore(uid, doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  // ── Save User Data to Firestore ─────────────────────────────────
  static Future<void> saveUserData({
    required String uid,
    required String name,
    required String email,
    String? avatar,
    String? birthday,
    String? babyName,
  }) async {
    final userRef = _db.collection('users').doc(uid);
    final doc = await userRef.get();

    final data = {
      'name': name,
      'email': email,
      'avatar': avatar,
      'birthday': birthday,
      'babyName': babyName,
      'membership': 'Platinum Member',
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Only set default stats if it's a brand new user
    if (!doc.exists) {
      data['points'] = 850;
      data['ordersCount'] = 0;
      data['createdAt'] = FieldValue.serverTimestamp();
    }

    await userRef.set(data, SetOptions(merge: true));
  }

  // ── Google Sign In ──────────────────────────────────────────────
  static Future<model.User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      if (user != null) {
        // Check if user exists, if not save them
        final existingProfile = await getUserProfile(user.uid);
        if (existingProfile == null) {
          await saveUserData(
            uid: user.uid,
            name: user.displayName ?? 'Google User',
            email: user.email ?? '',
            avatar: user.photoURL,
          );
        }

        // Fetch final profile
        final profile = await getUserProfile(user.uid);

        // Save to SharedPreferences for fast sync
        if (profile != null) {
          await register(name: profile.name, email: profile.email);
        }

        return profile;
      }

      return null;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  static Future<model.User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;

      if (user != null) {
        final profile = await getUserProfile(user.uid);
        if (profile != null) {
          await register(name: profile.name, email: profile.email);
        }
        return profile;
      }
      return null;
    } catch (e) {
      print('Error logging in: $e');
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
  static String? get currentUid => _auth.currentUser?.uid;
}
