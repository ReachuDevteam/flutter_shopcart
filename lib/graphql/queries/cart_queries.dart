import 'package:demo2/models/cartSupplierLineItems.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CartQueries {
  static const String getLineItemsBySupplierQuery = """
query GetLineItemsBySupplier(\$cartId: String!) {
  Cart {
    GetLineItemsBySupplier(cart_id: \$cartId) {
      supplier {
        id
        name
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
      }
    }
  }
}
  """;

  static Future<List<CartSupplierLineItems>>
      executeGetLineItemsBySupplierQueryQuery(
    GraphQLClient client,
    String cartId, {
    FetchPolicy fetchPolicy =
        FetchPolicy.networkOnly, // Por defecto, deshabilitar el cache
  }) async {
    final QueryResult result = await client.query(
      QueryOptions(
          document: gql(getLineItemsBySupplierQuery),
          variables: {"cartId": cartId},
          fetchPolicy: fetchPolicy),
    );

    if (result.hasException) {
      print(result.exception.toString());
      throw result.exception!;
    }

    List<dynamic> lineItemsBySupplierQueryData =
        result.data?['Cart']?['GetLineItemsBySupplier'] ?? [];

    return lineItemsBySupplierQueryData
        .map((supplierData) => CartSupplierLineItems.fromJson(supplierData))
        .toList();
  }
}
