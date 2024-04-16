import 'package:graphql_flutter/graphql_flutter.dart';

class CartMutations {
  static const String createCartMutation = """
    mutation CreateCart(\$customerSessionId: String!, \$currency: String!) {
      Cart {
        CreateCart(customer_session_id: \$customerSessionId, currency: \$currency) {
          cart_id
          customer_session_id
          shipping_country
          line_items {
            id
            supplier
            image {
              id
              url
              width
              height
            }
            sku
            barcode
            brand
            title
            product_id
            variant_id
            variant_title
            variant {
              option
              value
            }
            quantity
            price {
              amount
              currency_code
              tax
              discount
              compare_at
            }
            shipping {
              id
              name
              description
              price {
                amount
                currency_code
              }
            }
          }
          total_amount
          currency
          available_shipping_countries
        }
      }
    }
  """;

  static const String updateCartMutation = '''
    mutation UpdateCart(\$cartId: String!, \$shippingCountry: String!) {
      Cart {
        UpdateCart(cart_id: \$cartId, shipping_country: \$shippingCountry) {
          cart_id
          customer_session_id
          shipping_country
          line_items {
            id
            supplier
            image {
              id
              url
              width
              height
            }
            sku
            barcode
            brand
            title
            product_id
            variant_id
            variant_title
            variant {
              option
              value
            }
            quantity
            price {
              amount
              currency_code
              tax
              discount
              compare_at
            }
            shipping {
              id
              name
              description
              price {
                amount
                currency_code
              }
            }
          }
          total_amount
          currency
          available_shipping_countries
        }
      }
    }
  ''';

  static Future<Map<String, dynamic>?> executeCreateCartMutation(
      GraphQLClient client,
      {required String customerSessionId,
      required String currency}) async {
    final MutationOptions options = MutationOptions(
      document: gql(createCartMutation),
      variables: {
        'customerSessionId': customerSessionId,
        'currency': currency,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
      throw result.exception!;
    }

    return result.data?['Cart']?['CreateCart'] as Map<String, dynamic>?;
  }

  static Future<Map<String, dynamic>?> executeUpdateCartMutation(
      GraphQLClient client,
      {required String cartId,
      required String shippingCountry}) async {
    final MutationOptions options = MutationOptions(
      document: gql(updateCartMutation),
      variables: {
        'cartId': cartId,
        'shippingCountry': shippingCountry,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
      throw result.exception!;
    }

    return result.data?['Cart']?['UpdateCart'] as Map<String, dynamic>?;
  }
}
