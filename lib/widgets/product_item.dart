import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/cartItem.dart';
import '../state/app_state.dart';
import '../services/sdk.dart';
import '../widgets/product_detail_button.dart';

import 'package:reachu_flutter_sdk/reachu_flutter_sdk.dart' show LineItemInput;

class ProductItem extends StatefulWidget {
  final Product product;
  const ProductItem({super.key, required this.product});

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  int _quantity = 1;

  Future<void> _handleAddToCartItem(
    BuildContext context,
    CartItem cartItem,
  ) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final sdk = SdkService().sdk;

    try {
      final inputs = <LineItemInput>[
        LineItemInput(
          productId: cartItem.productId,
          quantity: cartItem.quantity,
        ),
      ];

      final updated = await sdk.cart.addItem(
        cart_id: appState.cartId,
        line_items: inputs, // <- lista tipada
      );

      final added = updated.lineItems.firstWhere(
        (li) => li.productId == cartItem.productId,
        orElse: () => updated.lineItems.isNotEmpty
            ? updated.lineItems.last
            : updated.lineItems.first,
      );

      cartItem.cartItemId = added.id;
      appState.addCartItem(cartItem);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added to cart')),
      );
    } catch (e) {
      debugPrint('Add to cart error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding product to cart')),
      );
    }
  }

  Future<void> _handleRemoveFromCartItem(
    BuildContext context,
    String cartItemId,
  ) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final sdk = SdkService().sdk;

    try {
      await sdk.cart.deleteItem(
        cart_id: appState.cartId,
        cart_item_id: cartItemId,
      );

      appState.removeCartItem(cartItemId);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product removed from cart')),
      );
    } catch (e) {
      debugPrint('Remove from cart error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing product: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isInCart =
        appState.cartItems.any((item) => item.productId == widget.product.id);

    CartItem? cartItem;
    if (isInCart) {
      cartItem = appState.cartItems
          .firstWhere((item) => item.productId == widget.product.id);
    }

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Image.network(
              widget.product.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            Text(
              widget.product.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text('${widget.product.currencyCode} ${widget.product.price}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: isInCart
                      ? null
                      : () {
                          if (_quantity > 1) {
                            setState(() => _quantity--);
                          }
                        },
                ),
                Text(
                  isInCart ? cartItem!.quantity.toString() : '$_quantity',
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed:
                      isInCart ? null : () => setState(() => _quantity++),
                ),
              ],
            ),
            ProductDetailButton(productId: widget.product.id),
            ElevatedButton(
              onPressed: () async {
                if (isInCart) {
                  await _handleRemoveFromCartItem(
                    context,
                    cartItem!.cartItemId,
                  );
                } else {
                  final newItem = CartItem(
                    title: widget.product.title,
                    currency: appState.selectedCurrency,
                    productId: widget.product.id,
                    quantity: _quantity,
                    unitPrice: widget.product.price,
                    tax: 0,
                    image: widget.product.imageUrl,
                    productShipping: widget.product.productShipping,
                    cartItemId: '',
                  );
                  await _handleAddToCartItem(context, newItem);
                }
                if (mounted) setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isInCart ? Colors.red : Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text(isInCart ? 'Remove from cart' : 'Add to cart'),
            ),
          ],
        ),
      ),
    );
  }
}
