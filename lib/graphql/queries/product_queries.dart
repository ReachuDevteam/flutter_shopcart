import 'package:demo2/models/product.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ProductQueries {
  static const String channelGetProductsQuery = """
    query ChannelGetProducts(\$currency: String, \$imageSize: ImageSize) {
      channelGetProducts(currency: \$currency, imageSize: \$imageSize) {
        id
        title
        description
        tags
        sku
        quantity
        price {
          amount
          currencyCode
          baseAmount
          compareAt
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
        subcategories {
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
        productShipping {
          id
          name
          description
          customPriceEnabled
          default
          shippingCountry {
            id
            amount
            country
            currencyCode
            originalData {
              amount
              currencyCode
              baseAmount
            }
          }
        }
        supplier
        importedProduct
        referralFee
        optionsEnabled
        digital
        origin
        return {
          return_right
          return_label
          return_cost
          supplier_policy
          return_address {
            sameAsBusiness
            sameAsWarehouse
            country
            timezone
            address
            address2
            postCode
            returnCity
          }
        }
      }
    }
  """;

  static const String channelGetProductQuery = """
    query ChannelGetProduct(\$currency: String, \$productId: Int, \$imageSize: ImageSize) {
      channelGetProduct(currency: \$currency, productId: \$productId, imageSize: \$imageSize) {
        id
        title
        description
        tags
        sku
        quantity
        price {
          amount
          currencyCode
          baseAmount
          compareAt
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
        subcategories {
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
        productShipping {
          id
          name
          description
          customPriceEnabled
          default
          shippingCountry {
            id
            amount
            country
            currencyCode
            originalData {
              amount
              currencyCode
              baseAmount
            }
          }
        }
        supplier
        importedProduct
        referralFee
        optionsEnabled
        digital
        origin
        return {
          return_right
          return_label
          return_cost
          supplier_policy
          return_address {
            sameAsBusiness
            sameAsWarehouse
            country
            timezone
            address
            address2
            postCode
            returnCity
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

    List<dynamic> data = result.data?['channelGetProducts'];
    return data.map((json) => Product.fromJson(json)).toList();
  }

  static Future<Product> executeChannelGetProductQuery(
      GraphQLClient client, int productId,
      {String? currency, String imageSize = 'large'}) async {
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(channelGetProductQuery),
        variables: {
          'currency': currency,
          'imageSize': imageSize,
          'productId': productId,
        },
      ),
    );

    if (result.hasException) {
      print(result.exception.toString());
      throw result.exception!;
    }

    Map<String, dynamic> data = result.data?['channelGetProduct'];
    return Product.fromJson(data);
  }
}
