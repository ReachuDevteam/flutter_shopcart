import 'package:demo2/graphql/mutations/cartItems_mutations.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/cartItem.dart';

class CartSummaryWidget extends StatelessWidget {
  const CartSummaryWidget({super.key});

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

  Future<void> _handleUpdateFromCart(
      BuildContext context, String cartItemId, int qty) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final GraphQLClient client = GraphQLProvider.of(context).value;

    try {
      var result = await CartItemMutations.updateItemToCart(
        client,
        appState.cartId,
        cartItemId,
        qty: qty,
      );

      if (result != null) {
        appState.updateCartItemQuantity(cartItemId, qty);
      } else {
        // If result is null, we handle the case as an error.
        throw Exception("Error updating product in cart: result is null");
      }
    } catch (e) {
      // Here you catch any exceptions that occur during the API call or result processing.
      print(e); // Log for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Error updating the product in the cart: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        double subtotal = appState.cartItems.fold(0,
            (total, current) => total + (current.unitPrice * current.quantity));

        return Column(
          children: [
            Expanded(
              child: ListView(
                children: appState.cartItems.map((CartItem cartItem) {
                  return ListTile(
                    leading: Image.network(cartItem.image),
                    title: Text(cartItem.title),
                    subtitle: Text(
                        '${cartItem.quantity} x ${cartItem.unitPrice.toStringAsFixed(2)} ${appState.selectedCurrency}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: cartItem.quantity > 1
                              ? () async {
                                  await _handleUpdateFromCart(
                                      context,
                                      cartItem.cartItemId,
                                      cartItem.quantity - 1);
                                }
                              : null,
                        ),
                        Text(cartItem.quantity.toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            await _handleUpdateFromCart(context,
                                cartItem.cartItemId, cartItem.quantity + 1);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await _handleRemoveFromCartItem(
                                context, cartItem.cartItemId);

                            if (appState.cartItems.isEmpty) {
                              Navigator.pop(
                                  context); //  Closes the cart summary if it is empty
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal:',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  Text(
                      '${subtotal.toStringAsFixed(2)} ${appState.selectedCurrency}',
                      style: const TextStyle(fontSize: 18.0)),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  Text(
                      '${subtotal.toStringAsFixed(2)} ${appState.selectedCurrency}',
                      style: const TextStyle(fontSize: 20.0)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
