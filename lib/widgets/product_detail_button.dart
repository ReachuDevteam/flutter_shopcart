import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../services/sdk.dart'; // <- usa tu singleton del reachu_flutter_sdk

class ProductDetailButton extends StatelessWidget {
  final int productId;

  const ProductDetailButton({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showProductDetail(context, productId),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, color: Colors.white),
          SizedBox(width: 8),
          Text('Details'),
        ],
      ),
    );
  }

  Future<void> _showProductDetail(BuildContext context, int productId) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final sdk = SdkService().sdk;

    try {
      final dtos = await sdk.channel.product.getByIds(
        productIds: [productId],
        currency: appState.selectedCurrency,
        imageSize: 'large',
        useCache: true,
      );

      if (dtos.isEmpty) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product not found')),
        );
        return;
      }

      final dto = dtos.first;
      final imageUrl = dto.images.isNotEmpty ? dto.images.first.url : '';

      if (!context.mounted) return;
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
                padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
                child: ListView(
                  controller: scrollController,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Hero(
                      tag: 'product-image-${dto.id}',
                      child: Image.network(
                        imageUrl,
                        height: 250,
                        errorBuilder: (_, __, ___) => const SizedBox(
                          height: 250,
                          child: Center(child: Icon(Icons.broken_image)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      dto.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Html(
                      data: dto.description ?? '',
                      style: {
                        "body": Style(
                          fontSize: FontSize(16.0),
                          lineHeight: LineHeight.em(1.5),
                        ),
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                        'Price: ${dto.price.amount} ${dto.price.currencyCode}'),
                  ],
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      debugPrint('Product detail error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading product details')),
        );
      }
    }
  }
}
