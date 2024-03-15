import 'package:graphql_flutter/graphql_flutter.dart';

class CheckoutMutations {
  static const String createCheckoutMutation = '''
    mutation CreateCheckout(\$cartId: String!) {
      createCheckout(cartId: \$cartId) {
        createdAt
        updatedAt
        id
        deletedAt
        success_url
        cancel_url
        payment_method
        email
        status
        checkout_url
        origin_payment_id
        total_price
        total_tax
        total_line_items_price
        billing_address {
          id
          first_name
          last_name
          phone_code
          phone
          company
          address1
          address2
          city
          province
          province_code
          country
          country_code
          zip
        }
        shipping_address {
          id
          first_name
          last_name
          phone_code
          phone
          company
          address1
          address2
          city
          province
          province_code
          country
          country_code
          zip
        }
        total_amount_shipping
        availablePaymentMethods {
          name
        }
        discount_code
        total_discount
        cart {
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
    }
  ''';

  static const String updateCheckoutMutation = '''
    mutation UpdateCheckout(\$checkoutId: String!, \$email: String, \$billingAddress: AddressArgs, \$shippingAddress: AddressArgs) {
      updateCheckout(checkoutId: \$checkoutId, email: \$email, billing_address: \$billingAddress, shipping_address: \$shippingAddress) {
        createdAt
        updatedAt
        id
        deletedAt
        success_url
        cancel_url
        payment_method
        email
        status
        checkout_url
        origin_payment_id
        total_price
        total_tax
        total_line_items_price
        billing_address {
          id
          first_name
          last_name
          phone_code
          phone
          company
          address1
          address2
          city
          province
          province_code
          country
          country_code
          zip
        }
        shipping_address {
          id
          first_name
          last_name
          phone_code
          phone
          company
          address1
          address2
          city
          province
          province_code
          country
          country_code
          zip
        }
        total_amount_shipping
        availablePaymentMethods {
          name
        }
        discount_code
        total_discount
        cart {
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
    }
  ''';

  static const String checkoutInitPaymentKlarnaMutation = '''
    mutation CheckoutInitPaymentKlarna(\$checkoutId: String!, \$countryCode: String!, \$href: String!, \$email: String!) {
      checkoutInitPaymentKlarna(checkoutId: \$checkoutId, country_code: \$countryCode, href: \$href, email: \$email) {
        order_id
        status
        purchase_country
        purchase_currency
        locale
        billing_address {
          given_name
          family_name
          email
          street_address
          postal_code
          city
          country
        }
        shipping_address {
          given_name
          family_name
          email
          street_address
          postal_code
          city
          country
        }
        order_amount
        order_tax_amount
        total_line_items_price
        order_lines {
          type
          name
          quantity
          unit_price
          tax_rate
          total_amount
          total_discount_amount
          total_tax_amount
          merchant_data
        }
        merchant_urls {
          terms
          checkout
          confirmation
          push
        }
        html_snippet
        started_at
        last_modified_at
        options {
          allow_separate_shipping_address
          date_of_birth_mandatory
          require_validate_callback_success
          phone_mandatory
          auto_capture
        }
        shipping_options {
          id
          name
          price
          tax_amount
          tax_rate
          preselected
        }
        merchant_data
        selected_shipping_option {
          id
          name
          price
          tax_amount
          tax_rate
          preselected
        }
      }
    }
  ''';

  static const String checkoutInitPaymentStripeMutation = '''
    mutation CheckoutInitPaymentStripe(\$email: String!, \$paymentMethod: String!, \$successUrl: String!, \$checkoutId: String!) {
      checkoutInitPaymentStripe(email: \$email, payment_method: \$paymentMethod, success_url: \$successUrl, checkoutId: \$checkoutId) {
      checkout_url
        order_id
      }
    }
  ''';

  static const String checkoutPaymentIntentStripeMutation = '''
    mutation CheckoutPaymentIntentStripe(\$checkoutId: String!) {
      checkoutPaymentIntentStripe(checkoutId: \$checkoutId) {
      client_secret
      }
    }
  ''';

  static Future<Map<String, dynamic>?> createCheckout(
      GraphQLClient client, String cartId) async {
    final MutationOptions options = MutationOptions(
      document: gql(createCheckoutMutation),
      variables: {
        'cartId': cartId,
      },
    );

    final QueryResult result = await client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
      return null;
    }

    return result.data?['createCheckout'];
  }

  static Future<Map<String, dynamic>?> updateCheckout(
      GraphQLClient client,
      String checkoutId,
      String email,
      Map<String, dynamic> billingAddress,
      Map<String, dynamic> shippingAddress) async {
    final MutationOptions options = MutationOptions(
      document: gql(updateCheckoutMutation),
      variables: {
        'checkoutId': checkoutId,
        'email': email,
        'billingAddress': billingAddress,
        'shippingAddress': shippingAddress,
      },
    );

    final QueryResult result = await client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
      return null;
    }

    return result.data?['updateCheckout'];
  }

  static Future<Map<String, dynamic>?> checkoutInitPaymentKlarna(
      GraphQLClient client,
      String checkoutId,
      String countryCode,
      String href,
      String email) async {
    final MutationOptions options = MutationOptions(
      document: gql(checkoutInitPaymentKlarnaMutation),
      variables: {
        'checkoutId': checkoutId,
        'countryCode': countryCode,
        'href': href,
        'email': email,
      },
    );

    final QueryResult result = await client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
      return null;
    }

    return result.data?['checkoutInitPaymentKlarna'];
  }

  static Future<Map<String, dynamic>?> checkoutInitPaymentStripe(
      GraphQLClient client,
      String email,
      String paymentMethod,
      String successUrl,
      String checkoutId) async {
    final MutationOptions options = MutationOptions(
      document: gql(checkoutInitPaymentStripeMutation),
      variables: {
        'email': email,
        'paymentMethod': paymentMethod,
        'successUrl': successUrl,
        'checkoutId': checkoutId,
      },
    );

    final QueryResult result = await client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
      return null;
    }

    return result.data?['checkoutInitPaymentStripe'];
  }

  static Future<Map<String, dynamic>?> checkoutPaymentIntentStripe(
      GraphQLClient client, String checkoutId) async {
    final MutationOptions options = MutationOptions(
      document: gql(checkoutPaymentIntentStripeMutation),
      variables: {
        'checkoutId': checkoutId,
      },
    );

    final QueryResult result = await client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
      return null;
    }

    return result.data?['checkoutPaymentIntentStripe'];
  }
}
