class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final String category;
  final double rating;
  final int stock;
  final String brand;
  final String thumbnail;
  final List<String> tags;
  final String shippingInformation;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.category,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.thumbnail,
    required this.tags,
    required this.shippingInformation,
  });

  double get discountPrice => price - ((price * discountPercentage) / 100);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],

      title: json['title'],

      description: json['description'],

      price: json['price'].toDouble(),

      discountPercentage: json['discountPercentage'].toDouble(),

      category: json['category'],

      rating: json['rating'].toDouble(),

      stock: json['stock'],

      brand: json['brand'] ?? "",

      thumbnail: json['thumbnail'],

      tags: ((json['tags'] ?? []) as List)
          .map((tag) => tag.toString())
          .toList(),

      shippingInformation: json['shippingInformation'] ?? "",
    );
  }
}
