class Specialist {
  final String id;
  final String name;
  final String role;
  final double rating;
  final String image;

  const Specialist({
    required this.id,
    required this.name,
    required this.role,
    required this.rating,
    required this.image,
  });

  factory Specialist.fromJson(Map<String, dynamic> json) {
    return Specialist(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      rating: (json['rating'] as num).toDouble(),
      image: json['image'] as String,
    );
  }
}
