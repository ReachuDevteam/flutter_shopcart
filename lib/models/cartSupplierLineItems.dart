class CartSupplierLineItems {
  final Supplier supplier;
  final List<AvailableShipping> availableShippings;
  final List<LineItem> lineItems;

  CartSupplierLineItems({
    required this.supplier,
    required this.availableShippings,
    required this.lineItems,
  });

  factory CartSupplierLineItems.fromJson(Map<String, dynamic> json) {
    return CartSupplierLineItems(
      supplier: Supplier.fromJson(json['supplier'] ?? {}),
      availableShippings: (json['available_shippings'] as List? ?? [])
          .map((shipping) => AvailableShipping.fromJson(shipping))
          .toList(),
      lineItems: (json['line_items'] as List? ?? [])
          .map((item) => LineItem.fromJson(item))
          .toList(),
    );
  }
}

class Supplier {
  final int id;
  final String name;

  Supplier({
    required this.id,
    required this.name,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Supplier',
    );
  }
}

class AvailableShipping {
  final String id;
  final String name;
  final String description;
  final String countryCode;
  final ShippingPrice price;

  AvailableShipping({
    required this.id,
    required this.name,
    required this.description,
    required this.countryCode,
    required this.price,
  });

  factory AvailableShipping.fromJson(Map<String, dynamic> json) {
    return AvailableShipping(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unnamed Shipping',
      description: json['description'] ?? 'No Description',
      countryCode: json['country_code'] ?? 'Unknown',
      price: ShippingPrice.fromJson(json['price'] ?? {}),
    );
  }
}

class ShippingPrice {
  final double amount;
  final String currencyCode;
  final double amountInclTaxes;
  final double taxAmount;
  final double taxRate;

  ShippingPrice({
    required this.amount,
    required this.currencyCode,
    required this.amountInclTaxes,
    required this.taxAmount,
    required this.taxRate,
  });

  factory ShippingPrice.fromJson(Map<String, dynamic> json) {
    return ShippingPrice(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currencyCode: json['currency_code'] ?? 'USD',
      amountInclTaxes: (json['amount_incl_taxes'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0.0,
      taxRate: (json['tax_rate'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class LineItem {
  final String id;
  final String supplier;
  final List<ProductImage> images;
  final String sku;
  final String barcode;
  final String brand;
  final int productId;
  final String title;
  final dynamic variantId;
  final dynamic variantTitle;
  final List<Variant> variants;
  final int quantity;
  final LineItemPrice price;
  final Shipping? shipping;

  LineItem({
    required this.id,
    required this.supplier,
    required this.images,
    required this.sku,
    required this.barcode,
    required this.brand,
    required this.productId,
    required this.title,
    this.variantId,
    this.variantTitle,
    required this.variants,
    required this.quantity,
    required this.price,
    this.shipping,
  });

  factory LineItem.fromJson(Map<String, dynamic> json) {
    return LineItem(
      id: json['id'] ?? '',
      supplier: json['supplier'] ?? 'Unknown Supplier',
      images: (json['image'] as List? ?? [])
          .map((img) => ProductImage.fromJson(img))
          .toList(),
      sku: json['sku'] ?? '',
      barcode: json['barcode'] ?? '',
      brand: json['brand'] ?? '',
      productId: json['product_id'] ?? 0,
      title: json['title'] ?? 'Untitled Product',
      variantId: json['variant_id'],
      variantTitle: json['variant_title'],
      variants: (json['variant'] as List? ?? [])
          .map((variant) => Variant.fromJson(variant))
          .toList(),
      quantity: json['quantity'] ?? 0,
      price: LineItemPrice.fromJson(json['price'] ?? {}),
      shipping:
          json['shipping'] != null ? Shipping.fromJson(json['shipping']) : null,
    );
  }
}

class ProductImage {
  final String id;
  final String url;
  final int width;
  final int height;

  ProductImage({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }
}

class Variant {
  final String option;
  final String value;

  Variant({
    required this.option,
    required this.value,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      option: json['option'] ?? '',
      value: json['value'] ?? '',
    );
  }
}

class LineItemPrice {
  final double amount;
  final String currencyCode;
  final double discount;
  final double compareAt;
  final double compareAtInclTaxes;
  final double amountInclTaxes;
  final double taxAmount;
  final double taxRate;

  LineItemPrice({
    required this.amount,
    required this.currencyCode,
    required this.discount,
    required this.compareAt,
    required this.compareAtInclTaxes,
    required this.amountInclTaxes,
    required this.taxAmount,
    required this.taxRate,
  });

  factory LineItemPrice.fromJson(Map<String, dynamic> json) {
    return LineItemPrice(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currencyCode: json['currency_code'] ?? '',
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      compareAt: (json['compare_at'] as num?)?.toDouble() ?? 0.0,
      compareAtInclTaxes:
          (json['compare_at_incl_taxes'] as num?)?.toDouble() ?? 0.0,
      amountInclTaxes: (json['amount_incl_taxes'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0.0,
      taxRate: (json['tax_rate'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class Shipping {
  final String id;
  final String name;
  final String description;
  final ShippingPrice price;

  Shipping({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Shipping.fromJson(Map<String, dynamic> json) {
    return Shipping(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unnamed Shipping',
      description: json['description'] ?? 'No Description',
      price: ShippingPrice.fromJson(json['price'] ?? {}),
    );
  }
}
