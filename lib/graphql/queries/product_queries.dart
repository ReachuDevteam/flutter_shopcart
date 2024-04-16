import 'package:demo2/models/product.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ProductQueries {
  static const String channelGetProductsQuery = """
    query GetProducts(\$currency: String, \$imageSize: ImageSize) {
      Channel {
        GetProducts(currency: \$currency, image_size: \$imageSize) {
          id
          title
          description
          tags
          sku
          quantity
          price {
            amount
            currency_code
            compare_at
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
              amount
              country
              currency_code
            }
          }
          supplier
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
    query GetProduct(\$currency: String, \$imageSize: ImageSize, \$sku: String, \$barcode: String, \$productId: Int) {
      Channel {
        GetProduct(currency: \$currency, image_size: \$imageSize, sku: \$sku, barcode: \$barcode, product_id: \$productId) {
          id
          title
          description
          tags
          sku
          quantity
          price {
            amount
            currency_code
            compare_at
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
              amount
              country
              currency_code
            }
          }
          supplier
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
      String imageSize = 'large'}) async {
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(channelGetProductsQuery),
        variables: {
          'currency': currency,
          'imageSize': imageSize,
        },
      ),
    );

    if (result.hasException) {
      print(result.exception.toString());
      throw result.exception!;
    }

    List<dynamic> data = result.data?['Channel']?['GetProducts'];
    return data.map((json) => Product.fromJson(json)).toList();
  }

  static Future<Product> executeChannelGetProductQuery(
      GraphQLClient client, int productId,
      {String? currency,
      String? sku,
      String? barcode,
      String? imageSize = 'large'}) async {
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(channelGetProductQuery),
        variables: {
          'currency': currency,
          'imageSize': imageSize,
          'productId': productId,
          "barcode": barcode,
          "sku": sku,
        },
      ),
    );

    if (result.hasException) {
      print(result.exception.toString());
      throw result.exception!;
    }

    Map<String, dynamic> data = result.data?['Channel']?['GetProduct'];
    return Product.fromJson(data);
  }
}
