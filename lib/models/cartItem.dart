class CartItem {
  int quantity;
  int productId;
  double unitPrice;
  double tax;
  String currency;
  String image;
  String title;
  String cartItemId;
  List<Object?>? productShipping;

  CartItem(
      {required this.title,
      required this.image,
      required this.quantity,
      required this.productId,
      required this.unitPrice,
      required this.currency,
      required this.tax,
      required this.cartItemId,
      this.productShipping});
}
