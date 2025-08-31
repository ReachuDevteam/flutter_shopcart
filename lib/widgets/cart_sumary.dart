import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../models/cartItem.dart';
import '../services/sdk.dart'; // <- usa tu singleton del reachu_flutter_sdk

class CartSummaryWidget extends StatelessWidget {
  const CartSummaryWidget({super.key});

  Future<void> _handleRemoveFromCartItem(
      BuildContext context, String cartItemId) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final sdk = SdkService().sdk;

    try {
      // SDK: eliminar item del carrito
      await sdk.cart.deleteItem(
        cart_id: appState.cartId,
        cart_item_id: cartItemId,
      );

      // Mantener misma lógica local
      appState.removeCartItem(cartItemId);
    } catch (e) {
      // Log y feedback
      // ignore: avoid_print
      print(e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Error removing product from cart: ${e.toString()}")),
        );
      }
    }
  }

  Future<void> _handleUpdateFromCart(
      BuildContext context, String cartItemId, int qty) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final sdk = SdkService().sdk;

    try {
      // SDK: actualizar cantidad del item
      await sdk.cart.updateItem(
        cart_id: appState.cartId,
        cart_item_id: cartItemId,
        quantity: qty,
      );

      // Mantener misma lógica local
      appState.updateCartItemQuantity(cartItemId, qty);
    } catch (e) {
      // ignore: avoid_print
      print(e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Error updating the product in the cart: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final subtotal = appState.cartItems.fold<double>(
          0,
          (total, current) => total + (current.unitPrice * current.quantity),
        );

        return Column(
          children: [
            Expanded(
              child: ListView(
                children: appState.cartItems.map((CartItem cartItem) {
                  return ListTile(
                    leading: Image.network(cartItem.image),
                    title: Text(cartItem.title),
                    subtitle: Text(
                      '${cartItem.quantity} x ${cartItem.unitPrice.toStringAsFixed(2)} ${appState.selectedCurrency}',
                    ),
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
                                    cartItem.quantity - 1,
                                  );
                                }
                              : null,
                        ),
                        Text(cartItem.quantity.toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            await _handleUpdateFromCart(
                              context,
                              cartItem.cartItemId,
                              cartItem.quantity + 1,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await _handleRemoveFromCartItem(
                              context,
                              cartItem.cartItemId,
                            );

                            if (appState.cartItems.isEmpty && context.mounted) {
                              // cierra el resumen si queda vacío
                              Navigator.pop(context);
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
                  const Text(
                    'Subtotal:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${subtotal.toStringAsFixed(2)} ${appState.selectedCurrency}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${subtotal.toStringAsFixed(2)} ${appState.selectedCurrency}',
                    style: const TextStyle(fontSize: 20.0),
                  ),
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
