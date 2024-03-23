import 'package:demo2/graphql/mutations/cartItems_mutations.dart';
import 'package:demo2/widgets/product_detail_button.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/cartItem.dart';
import '../state/app_state.dart';

class ProductItem extends StatefulWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  int _quantity = 1;

  Future<void> _handleAddToCartItem(
      BuildContext context, CartItem cartItem) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final GraphQLClient client = GraphQLProvider.of(context).value;

    try {
      var result = await CartItemMutations.createItemToCart(
        client,
        appState.cartId,
        [
          {
            'product_id': cartItem.productId,
            'quantity': cartItem.quantity,
            "price_data": {
              "currency": appState.selectedCurrency,
              "tax": 0,
              "unit_price": cartItem.unitPrice,
            },
          }
        ],
      );

      if (result != null) {
        final matchingLineItem = result['line_items'].firstWhere(
          (item) => item['product_id'] == cartItem.productId,
          orElse: () => null,
        );
        if (matchingLineItem != null) {
          cartItem.cartItemId = matchingLineItem['id'];
          appState.addCartItem(cartItem);
        }
      } else {
        throw Exception("Product could not be added to cart.");
      }
    } catch (e) {
      // Optional: print the error in the console for debugging purposes
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Error adding product to cart. Please try again later")),
      );
    }
  }

  Future<void> _handleRemoveFromCartItem(
      BuildContext context, String cartItemId) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final GraphQLClient client = GraphQLProvider.of(context).value;

    try {
      var result = await CartItemMutations.removeItemFromCart(
        client,
        appState.cartId,
        cartItemId,
      );

      if (result != null) {
        appState.removeCartItem(cartItemId);
      } else {
        // If result is null, we handle the case as an error.
        throw Exception("Error removing product from cart: result is null");
      }
    } catch (e) {
      // Here you catch any exceptions that occur during the API call or result processing.
      print(e); // Log for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Error removing product from cart: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isInCart = appState.cartItems
        .any((item) => item.productId == int.parse(widget.product.id));
    CartItem? cartItem;
    if (isInCart) {
      cartItem = appState.cartItems
          .firstWhere((item) => item.productId == int.parse(widget.product.id));
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
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
                Text(isInCart ? cartItem!.quantity.toString() : '$_quantity',
                    style: const TextStyle(fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: isInCart
                      ? null
                      : () {
                          setState(() => _quantity++);
                        },
                ),
              ],
            ),
            ProductDetailButton(
                productId: int.parse(widget.product
                    .id)), // Here you integrate your ProductDetailButton
            ElevatedButton(
              onPressed: () async {
                if (isInCart) {
                  await _handleRemoveFromCartItem(
                      context, cartItem!.cartItemId);
                } else {
                  CartItem _cartItem = CartItem(
                      title: widget.product.title,
                      currency: appState.selectedCurrency,
                      productId: int.parse(widget.product.id),
                      quantity: _quantity,
                      unitPrice: double.parse(widget.product.price),
                      tax: 0,
                      image: widget.product.imageUrl,
                      productShipping: widget.product.productShipping,
                      cartItemId: "");
                  await _handleAddToCartItem(context, _cartItem);
                }
                setState(() {});
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
