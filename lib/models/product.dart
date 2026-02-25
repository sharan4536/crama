class Product {
  final String title;
  final String sku;
  final double price;
  final int stock;
  final String imageUrl;

  Product({
    required this.title,
    required this.sku,
    required this.price,
    required this.stock,
    required this.imageUrl,
  });

  Product copyWith({
    String? title,
    String? sku,
    double? price,
    int? stock,
    String? imageUrl,
  }) {
    return Product(
      title: title ?? this.title,
      sku: sku ?? this.sku,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
