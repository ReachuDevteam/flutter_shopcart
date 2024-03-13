class Product {
  final String id;
  final String title;
  final String description;
  final String price;
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
      description: json['description'],
      productShipping: json['productShipping'],
      price: json['price']['amount'],
      currencyCode: json['price']['currencyCode'],
      imageUrl: json['images'][0]
          ['url'], // Asume que siempre hay al menos una imagen
    );
  }
}
