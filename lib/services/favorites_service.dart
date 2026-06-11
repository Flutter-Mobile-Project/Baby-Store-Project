import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static String _favoriteDocId(String title) =>
      Uri.encodeComponent(title.trim().toLowerCase());

  static CollectionReference<Map<String, dynamic>> _favoritesRef(String uid) {
    return _db.collection('users').doc(uid).collection('favorites');
  }

  static Stream<List<Map<String, String>>> favoritesStream(String uid) {
    return _favoritesRef(uid).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title']?.toString() ?? '',
          'category': data['category']?.toString() ?? '',
          'price': data['price']?.toString() ?? '',
          'image': data['image']?.toString() ?? '',
          if (data['description'] != null)
            'description': data['description']?.toString() ?? '',
        };
      }).toList();
    });
  }

  static Future<void> addFavorite(String uid, Map<String, String> item) async {
    final title = item['title'] ?? '';
    final id = title.isNotEmpty
        ? _favoriteDocId(title)
        : DateTime.now().millisecondsSinceEpoch.toString();

    await _favoritesRef(uid).doc(id).set({
      'title': title,
      'category': item['category'] ?? '',
      'price': item['price'] ?? '',
      'image': item['image'] ?? '',
      'description': item['description'] ?? '',
      'addedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Future<void> removeFavorite(String uid, String title) async {
    final id = _favoriteDocId(title);
    await _favoritesRef(uid).doc(id).delete();
  }
}
