import 'package:graphql_flutter/graphql_flutter.dart';

class CheckoutMutations {
  static const String createCheckoutMutation = '''
    mutation CreateCheckout(\$cartId: String!) {
      Checkout {
        CreateCheckout(cart_id: \$cartId) {
          buyer_accepts_purchase_conditions
          buyer_accepts_terms_conditions
          created_at
          updated_at
          id
          deleted_at
          success_url
          cancel_url
          payment_method
          email
          status
          checkout_url
          origin_payment_id
          total_amount
          total_taxes_amount
          total_cart_amount
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
          total_shipping_amount
          available_payment_methods {
            name
          }
          discount_code
          total_discount
          cart {
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
    }
  ''';

  static const String updateCheckoutMutation = '''
    mutation UpdateCheckout(
      \$checkoutId: String!
      \$buyerAcceptsTermsConditions: Boolean
      \$buyerAcceptsPurchaseConditions: Boolean
      \$billingAddress: AddressArgs
      \$shippingAddress: AddressArgs
      \$paymentMethod: String
      \$cancelUrl: String
      \$successUrl: String
      \$email: String
      \$status: String
    ) {
      Checkout {
        UpdateCheckout(
          checkout_id: \$checkoutId
          buyer_accepts_terms_conditions: \$buyerAcceptsTermsConditions
          buyer_accepts_purchase_conditions: \$buyerAcceptsPurchaseConditions
          billing_address: \$billingAddress
          shipping_address: \$shippingAddress
          payment_method: \$paymentMethod
          cancel_url: \$cancelUrl
          success_url: \$successUrl
          email: \$email
          status: \$status
        ) {
          buyer_accepts_purchase_conditions
          buyer_accepts_terms_conditions
          created_at
          updated_at
          id
          deleted_at
          success_url
          cancel_url
          payment_method
          email
          status
          checkout_url
          origin_payment_id
          total_amount
          total_taxes_amount
          total_cart_amount
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
          total_shipping_amount
          available_payment_methods {
            name
          }
          discount_code
          total_discount
          cart {
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
    }
  ''';

  static const String checkoutInitPaymentKlarnaMutation = '''
    mutation CreatePaymentKlarna(\$checkoutId: String!, \$countryCode: String!, \$href: String!, \$email: String!) {
      Payment {
        CreatePaymentKlarna(checkout_id: \$checkoutId, country_code: \$countryCode, href: \$href, email: \$email) {
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
    }
  ''';

  static const String checkoutInitPaymentStripeMutation = '''
    mutation CreatePaymentIntentStripe(\$checkoutId: String!, \$successUrl: String!, \$paymentMethod: String!, \$email: String!) {
      Payment {
        CreatePaymentStripe(checkout_id: \$checkoutId, success_url: \$successUrl, payment_method: \$paymentMethod, email: \$email) {
          checkout_url
          order_id
        }
      }
    }
  ''';

  static const String checkoutPaymentIntentStripeMutation = '''
    mutation CreatePaymentIntentStripe(\$checkoutId: String!, \$returnEphemeralKey: Boolean) {
      Payment {
        CreatePaymentIntentStripe(checkout_id: \$checkoutId, return_ephemeral_key: \$returnEphemeralKey) {
          client_secret
          customer
          publishable_key
          ephemeral_key
        }
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

    return result.data?['Checkout']?['CreateCheckout'];
  }

  static Future<Map<String, dynamic>?> updateCheckout(
      GraphQLClient client,
      String checkoutId,
      String email,
      Map<String, dynamic> billingAddress,
      Map<String, dynamic> shippingAddress,
      bool buyerAcceptsTermsConditions,
      bool buyerAcceptsPurchaseConditions) async {
    final MutationOptions options = MutationOptions(
      document: gql(updateCheckoutMutation),
      variables: {
        'checkoutId': checkoutId,
        'email': email,
        'billingAddress': billingAddress,
        'shippingAddress': shippingAddress,
        'buyerAcceptsTermsConditions': buyerAcceptsTermsConditions,
        'buyerAcceptsPurchaseConditions': buyerAcceptsPurchaseConditions,
      },
    );

    final QueryResult result = await client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
      return null;
    }

    return result.data?['Checkout']?['UpdateCheckout'];
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

    return result.data?['Payment']?['CreatePaymentKlarna'];
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

    return result.data?['Payment']?['CreatePaymentStripe'];
  }

  static Future<Map<String, dynamic>?> checkoutPaymentIntentStripe(
      GraphQLClient client, String checkoutId, bool returnEphemeralKey) async {
    final MutationOptions options = MutationOptions(
      document: gql(checkoutPaymentIntentStripeMutation),
      variables: {
        'checkoutId': checkoutId,
        'returnEphemeralKey': returnEphemeralKey,
      },
    );

    final QueryResult result = await client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
      return null;
    }

    return result.data?['Payment']?['CreatePaymentIntentStripe'];
  }
}
