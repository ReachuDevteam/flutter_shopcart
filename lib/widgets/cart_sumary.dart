import 'package:demo2/graphql/mutations/cartItems_mutations.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/cartItem.dart'; // Asegúrate de tener este modelo definido

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
        // Si result es null, manejamos el caso como un error.
        throw Exception("Error removing product from cart: result is null");
      }
    } catch (e) {
      // Aquí capturas cualquier excepción que ocurra durante la llamada a la API o procesamiento del resultado.
      print(e); // Log para depuraciónx
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
        // Si result es null, manejamos el caso como un error.
        throw Exception(
            "Error al actualizar el producto del carrito: result es null");
      }
    } catch (e) {
      // Aquí capturas cualquier excepción que ocurra durante la llamada a la API o procesamiento del resultado.
      print(e); // Log para depuración
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

                            // appState.removeCartItem(cartItem.cartItemId);
                            if (appState.cartItems.isEmpty) {
                              Navigator.pop(
                                  context); // Cierra el resumen del carrito si está vacío
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
            // Puedes agregar aquí otros costos como impuestos o envío antes del total final
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
