class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
    required this.stock,
  });

  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;
  final int stock;

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'] as List<dynamic>? ?? const [];
    final images = rawImages.whereType<String>().where((e) => e.isNotEmpty).toList();
    final thumbnail = json['thumbnail'] as String? ?? '';
    if (images.isEmpty && thumbnail.isNotEmpty) images.add(thumbnail);

    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? 'Product',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      brand: json['brand'] as String? ?? '',
      category: json['category'] as String? ?? '',
      thumbnail: thumbnail.isNotEmpty ? thumbnail : (images.isNotEmpty ? images.first : ''),
      images: images,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
    );
  }

  double get discountedPrice => price * (1 - discountPercentage / 100);
}
