import 'package:graphql_flutter/graphql_flutter.dart';

class CartItemMutations {
  static const String createItemToCartMutation = '''
    mutation AddItem(\$cartId: String!, \$lineItems: [LineItemInput!]!) {
      Cart {
        AddItem(cart_id: \$cartId, line_items: \$lineItems) {
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
        product_id
        title
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
          discount
          compare_at
          compare_at_incl_taxes
          amount_incl_taxes
          tax_amount
          tax_rate
        }
        shipping {
          id
          name
          description
          price {
            amount
            currency_code
            amount_incl_taxes
            tax_amount
            tax_rate
          }
        }
        available_shippings {
          id
          name
          description
          country_code
          price {
            amount
            currency_code
            amount_incl_taxes
            tax_amount
            tax_rate
          }
        }
      }
      subtotal
      shipping
      currency
      available_shipping_countries
        }
      }
    }
  ''';

  static const String updateItemToCartMutation = '''
    mutation UpdateItem(\$cartId: String!, \$cartItemId: String!, \$shippingId: String, \$qty: Int) {
      Cart {
        UpdateItem(cart_id: \$cartId, cart_item_id: \$cartItemId, shipping_id: \$shippingId, qty: \$qty) {
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
        product_id
        title
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
          discount
          compare_at
          compare_at_incl_taxes
          amount_incl_taxes
          tax_amount
          tax_rate
        }
        shipping {
          id
          name
          description
          price {
            amount
            currency_code
            amount_incl_taxes
            tax_amount
            tax_rate
          }
        }
        available_shippings {
          id
          name
          description
          country_code
          price {
            amount
            currency_code
            amount_incl_taxes
            tax_amount
            tax_rate
          }
        }
      }
      subtotal
      shipping
      currency
      available_shipping_countries
        }
      }
    }
  ''';

  static const String removeItemToCartMutation = """
    mutation DeleteItem(\$cartId: String!, \$cartItemId: String!) {
      Cart {
        DeleteItem(cart_id: \$cartId, cart_item_id: \$cartItemId) {
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
        product_id
        title
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
          discount
          compare_at
          compare_at_incl_taxes
          amount_incl_taxes
          tax_amount
          tax_rate
        }
        shipping {
          id
          name
          description
          price {
            amount
            currency_code
            amount_incl_taxes
            tax_amount
            tax_rate
          }
        }
        available_shippings {
          id
          name
          description
          country_code
          price {
            amount
            currency_code
            amount_incl_taxes
            tax_amount
            tax_rate
          }
        }
      }
      subtotal
      shipping
      currency
      available_shipping_countries
        }
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

    return result.data?['Cart']?['AddItem'];
  }

  static Future<Map<String, dynamic>?> updateItemToCart(
      GraphQLClient client, String cartId, String cartItemId,
      {String? shippingId, int? qty}) async {
    final Map<String, dynamic> variables = {
      'cartId': cartId,
      'cartItemId': cartItemId,
      'shippingId': shippingId,
    };

    if (qty != null) {
      variables['qty'] = qty;
    }

    final MutationOptions options = MutationOptions(
      document: gql(CartItemMutations.updateItemToCartMutation),
      variables: variables,
    );

    final result = await client.mutate(options);

    if (result.hasException) {
      throw result.exception!;
    }

    return result.data?['Cart']?['UpdateItem'];
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

    return result.data?['Cart']?['DeleteItem'] as Map<String, dynamic>?;
  }
}
