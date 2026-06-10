class User {
  final String uid;
  final String name;
  final String email;
  final String membership;
  final String? avatar;
  final int points;
  final int ordersCount;
  final String? babyName;
  final String? babyBirthday;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.membership,
    this.avatar,
    this.points = 0,
    this.ordersCount = 0,
    this.babyName,
    this.babyBirthday,
  });

  factory User.fromFirestore(String uid, Map<String, dynamic> data) {
    return User(
      uid: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      membership: data['membership'] ?? 'Standard Member',
      avatar: data['avatar'],
      points: data['points'] ?? 0,
      ordersCount: data['ordersCount'] ?? 0,
      babyName: data['babyName'],
      babyBirthday: data['birthday'], // Using birthday field for baby info
    );
  }
}
