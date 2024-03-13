import 'package:graphql_flutter/graphql_flutter.dart';

class CartMutations {
  static const String createCartMutation = """
    mutation CreateCart(\$customerSessionId: String!, \$currency: String!) {
      createCart(customerSessionId: \$customerSessionId, currency: \$currency) {
        cart_id
        currency
      }
    }
  """;

  static const String updateCartMutation = '''
    mutation UpdateCart(\$cartId: String!, \$shippingCountry: String!) {
      updateCart(cartId: \$cartId, shipping_country: \$shippingCountry) {
        cart_id
        customer_session_id
        shippingCountry
        line_items {
          id
          supplier
          product_image {
            id
            url
            width
            height
          }
          product_id
          product_title
          variant_id
          variant_title
          variant {
            option
            value
          }
          quantity
          price {
            amount
            currencyCode
            tax
            discount
            compareAt
          }
          shipping {
            id
            name
            description
            price {
              amount
              currencyCode
            }
          }
        }
        total_amount
        currency
        available_shipping_countries
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

    return result.data?['createCart'] as Map<String, dynamic>?;
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

    return result.data?['updateCart'] as Map<String, dynamic>?;
  }
}
