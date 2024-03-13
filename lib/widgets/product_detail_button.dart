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
    // Botón personalizado acorde a tu diseño
    return ElevatedButton(
      onPressed: () => _showProductDetail(context, productId),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent, // Color de fondo
        foregroundColor: Colors.white, // Color del contenido (texto, icono)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Borde redondeado
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, color: Colors.white), // Icono del botón
          SizedBox(width: 8),
          Text('Details') // Texto del botón
        ],
      ),
    );
  }

  void _showProductDetail(BuildContext context, int productId) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final GraphQLClient client = GraphQLProvider.of(context).value;

    // Aquí haces tu llamada al servicio para obtener el detalle del producto.
    var product = await ProductQueries.executeChannelGetProductQuery(
        client, productId,
        currency: appState.selectedCurrency);

    // Mostrar el detalle del producto en una hoja modal.
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
                    data: product.description, // Aquí va tu texto en HTML
                    // Aquí puedes personalizar el estilo de los elementos HTML, si es necesario
                    style: {
                      "body": Style(
                        fontSize: FontSize(16.0),
                        lineHeight: LineHeight.em(
                            1.5), // Ajustar la altura de línea según necesites
                      ),
                      // Añade más estilos para otros elementos si es necesario
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
