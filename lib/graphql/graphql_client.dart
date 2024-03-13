import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GraphQLConfiguration {
  static HttpLink httpLink = HttpLink(
    dotenv.env['GRAPHQL_SERVER_URL']!,
  );

  static AuthLink authLink = AuthLink(
    getToken: () async => '${dotenv.env['API_TOKEN']}',
  );

  static Link link = authLink.concat(httpLink);

  static ValueNotifier<GraphQLClient> clientToQuery() {
    return ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(),
        link: link,
      ),
    );
  }
}
