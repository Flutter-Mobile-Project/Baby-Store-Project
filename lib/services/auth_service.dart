import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // ── In-memory fast access ───────────────────────────────────────
  static bool isRegistered = false;
  static String? _userName;
  static String? _userEmail;

  // ── Keys ────────────────────────────────────────────────────────
  static const String _keyRegistered = 'auth_is_registered';
  static const String _keyUserName = 'auth_user_name';
  static const String _keyUserEmail = 'auth_user_email';

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
    // Clear in-memory
    isRegistered = false;
    _userName = null;
    _userEmail = null;

    // Clear from device storage
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

  // ── Getters ─────────────────────────────────────────────────────
  static String? get userName => _userName;
  static String? get userEmail => _userEmail;
}
