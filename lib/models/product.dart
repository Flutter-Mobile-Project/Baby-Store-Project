// lib/models/product_model.dart

class Product {
  final String brand;
  final String title;
  final double price;
  final String image;

  Product({
    required this.brand,
    required this.title,
    required this.price,
    required this.image,
  });

  // Helper constructor to convert API / Map data into this clean object
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      brand: map['brand'] ?? '',
      title: map['title'] ?? '',
      price: (map['price'] as num).toDouble(),
      image: map['image'] ?? '',
    );
  }
}
