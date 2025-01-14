// File: lib/models/product.dart
class Product {
  final String title;
  final double pricing;
  final List<String> images;
  final String description;

  // Constructor untuk inisialisasi data
  Product({
    required this.title,
    required this.pricing,
    required this.images,
    required this.description,
  });

  // Fungsi untuk mengonversi objek Product menjadi map (format JSON)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'pricing': pricing,
      'images': images,
      'description': description,
    };
  }

  // Fungsi untuk membuat objek Product dari map (format JSON)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      title: map['title'] ?? '',
      pricing: double.tryParse(map['pricing'].toString()) ?? 0.0, // Pastikan pricing adalah double
      images: List<String>.from(map['images'] ?? []),
      description: map['description'] ?? '',
    );
  }
}
