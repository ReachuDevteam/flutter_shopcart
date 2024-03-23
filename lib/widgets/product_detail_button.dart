import 'package:demo2/graphql/queries/product_queries.dart';
import 'package:demo2/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class ProductDetailButton extends StatelessWidget {
  final int productId;

  ProductDetailButton({required this.productId});

  @override
  Widget build(BuildContext context) {
    // Personalized button according to your design
    return ElevatedButton(
      onPressed: () => _showProductDetail(context, productId),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, color: Colors.white),
          SizedBox(width: 8),
          Text('Details')
        ],
      ),
    );
  }

  void _showProductDetail(BuildContext context, int productId) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final GraphQLClient client = GraphQLProvider.of(context).value;

    // Here you make your service call to get the product detail..
    var product = await ProductQueries.executeChannelGetProductQuery(
        client, productId,
        currency: appState.selectedCurrency);

    // Show the product detail in a modal sheet.
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 0),
              child: ListView(
                controller: scrollController,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Hero(
                    tag: 'product-image-${product.id}',
                    child: Image.network(product.imageUrl, height: 250),
                  ),
                  SizedBox(height: 20),
                  Text(
                    product.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Html(
                    data: product.description,
                    style: {
                      "body": Style(
                        fontSize: FontSize(16.0),
                        lineHeight: LineHeight.em(1.5),
                      ),
                    },
                  ),
                  SizedBox(height: 20),
                  Text('Price: ${product.price} ${product.currencyCode}'),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
