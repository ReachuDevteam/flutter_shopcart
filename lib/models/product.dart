class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String currencyCode;
  final String imageUrl;
  final List<Object?>? productShipping;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.currencyCode,
      required this.imageUrl,
      this.productShipping});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      productShipping: json['product_shipping'],
      price: json['price']['amount'],
      currencyCode: json['price']['currency_code'],
      imageUrl: json['images'][0]
          ['url'], // Assumes there is always at least one image.
    );
  }
}
