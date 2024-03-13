import 'package:graphql_flutter/graphql_flutter.dart';

class CartItemMutations {
  static const String createItemToCartMutation = '''
    mutation CreateItemToCart(\$cartId: String!, \$lineItems: [LineItemInput!]!) {
      createItemToCart(cartId: \$cartId, line_items: \$lineItems) {
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

  static const String updateItemToCartMutation = '''
    mutation UpdateItemToCart(\$cartId: String!, \$cartItemId: String!, \$shippingId: String, \$qty: Int) {
      updateItemToCart(cartId: \$cartId, cartItemId: \$cartItemId, shipping_id: \$shippingId, qty: \$qty) {
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

  static const String removeItemToCartMutation = """
    mutation RemoveItemToCart(\$cartId: String!, \$cartItemId: String!) {
      removeItemToCart(cartId: \$cartId, cartItemId: \$cartItemId) {
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
  """;

  static Future<Map<String, dynamic>?> createItemToCart(GraphQLClient client,
      String cartId, List<Map<String, dynamic>> lineItems) async {
    final MutationOptions options = MutationOptions(
      document: gql(CartItemMutations.createItemToCartMutation),
      variables: {
        'cartId': cartId,
        'lineItems': lineItems,
      },
    );

    final result = await client.mutate(options);
    if (result.hasException) {
      throw result.exception!;
    }

    return result.data?['createItemToCart'];
  }

  static Future<Map<String, dynamic>?> updateItemToCart(
      GraphQLClient client, String cartId, String cartItemId,
      {String? shippingId, int? qty}) async {
    final MutationOptions options = MutationOptions(
      document: gql(CartItemMutations.updateItemToCartMutation),
      variables: {
        'cartId': cartId,
        'cartItemId': cartItemId,
        'shippingId': shippingId,
        'qty': qty,
      },
    );

    final result = await client.mutate(options);
    if (result.hasException) {
      throw result.exception!;
    }

    return result.data?['updateItemToCart'];
  }

  static Future<Map<String, dynamic>?> removeItemFromCart(
      GraphQLClient client, String cartId, String cartItemId) async {
    final MutationOptions options = MutationOptions(
      document: gql(CartItemMutations.removeItemToCartMutation),
      variables: {
        'cartId': cartId,
        'cartItemId': cartItemId,
      },
    );

    final result = await client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
      throw result.exception!;
    }

    return result.data?['removeItemToCart'] as Map<String, dynamic>?;
  }
}
