import 'package:demo2/models/market.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MarketQueries {
  static const String getAvailableMarketsQuery = """
  query GetAvailableMarkets {
    Channel {
      GetAvailableMarkets {
        name
        code
        flag
        currency {
          code
          name
          symbol
        }
      }
    }
  }
  """;

  static Future<List<Market>> executeGetAvailableMarketsQuery(
      GraphQLClient client) async {
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(getAvailableMarketsQuery),
        variables: {},
      ),
    );

    if (result.hasException) {
      print(result.exception.toString());
      throw result.exception!;
    }

    List<dynamic> marketsData =
        result.data?['Channel']?['GetAvailableMarkets'] ?? [];
    return marketsData
        .map((marketJson) => Market.fromJson(marketJson))
        .toList();
  }
}
