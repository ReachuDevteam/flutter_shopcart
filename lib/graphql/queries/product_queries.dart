import 'package:demo2/models/product.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ProductQueries {
  static const String channelGetProductsQuery = """
    query Products(\$currency: String, \$imageSize: ImageSize, \$shippingCountryCode: String) {
      Channel {
        Products(currency: \$currency, image_size: \$imageSize, shipping_country_code: \$shippingCountryCode) {
      id
      title
      brand
      description
      tags
      sku
      quantity
      price {
        amount
        currency_code
        amount_incl_taxes
        tax_amount
        tax_rate
        compare_at
        compare_at_incl_taxes
      }
      variants {
        id
        barcode
        quantity
        sku
        title
      }
      barcode
      options {
        id
        name
        order
        values
      }
      categories {
        id
        name
      }
      images {
        id
        url
        width
        height
        order
      }
      product_shipping {
        id
        name
        description
        custom_price_enabled
        default
        shipping_country {
          id
          country
          price {
            amount
            currency_code
            amount_incl_taxes
            tax_amount
            tax_rate
          }
        }
      }
      supplier
      supplier_id
      imported_product
      referral_fee
      options_enabled
      digital
      origin
      return {
        return_right
        return_label
        return_cost
        supplier_policy
        return_address {
          same_as_business
          same_as_warehouse
          country
          timezone
          address
          address_2
          post_code
          return_city
        }
      }
        }
      }
    }
  """;

  static const String channelGetProductQuery = """
    query Products(\$currency: String, \$imageSize: ImageSize, \$shippingCountryCode: String, \$productIds: [Int!]!) {
      Channel {
        Products(currency: \$currency, image_size: \$imageSize, shipping_country_code: \$shippingCountryCode, product_ids: \$productIds) {
      id
      title
      brand
      description
      tags
      sku
      quantity
      price {
        amount
        currency_code
        amount_incl_taxes
        tax_amount
        tax_rate
        compare_at
        compare_at_incl_taxes
      }
      variants {
        id
        barcode
        quantity
        sku
        title
      }
      barcode
      options {
        id
        name
        order
        values
      }
      categories {
        id
        name
      }
      images {
        id
        url
        width
        height
        order
      }
      product_shipping {
        id
        name
        description
        custom_price_enabled
        default
        shipping_country {
          id
          country
          price {
            amount
            currency_code
            amount_incl_taxes
            tax_amount
            tax_rate
          }
        }
      }
      supplier
      supplier_id
      imported_product
      referral_fee
      options_enabled
      digital
      origin
      return {
        return_right
        return_label
        return_cost
        supplier_policy
        return_address {
          same_as_business
          same_as_warehouse
          country
          timezone
          address
          address_2
          post_code
          return_city
        }
      }
        }
      }
    }
  """;

  static Future<List<Product>> executeChannelGetProductsQuery(
      GraphQLClient client,
      {String? currency,
      String? shippingCountryCode,
      String imageSize = 'large'}) async {
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(channelGetProductsQuery),
        variables: {
          'currency': currency,
          'imageSize': imageSize,
          "shippingCountryCode": shippingCountryCode
        },
      ),
    );

    if (result.hasException) {
      print(result.exception.toString());
      throw result.exception!;
    }

    List<dynamic> data = result.data?['Channel']?['Products'];
    return data.map((json) => Product.fromJson(json)).toList();
  }

  static Future<Product> executeChannelGetProductQuery(
      GraphQLClient client, int productId,
      {String? currency,
      String? shippingCountryCode,
      String? imageSize = 'large'}) async {
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(channelGetProductQuery),
        variables: {
          'currency': currency,
          'imageSize': imageSize,
          'productIds': [productId],
          "shippingCountryCode": shippingCountryCode
        },
      ),
    );

    if (result.hasException) {
      print(result.exception.toString());
      throw result.exception!;
    }

    List<dynamic> data = result.data?['Channel']?['Products'];
    return Product.fromJson(data.first);
  }
}
