import 'package:demo2/widgets/cart_sumary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class CartIconWidget extends StatefulWidget {
  const CartIconWidget({super.key});

  @override
  _CartIconWidgetState createState() => _CartIconWidgetState();
}

class _CartIconWidgetState extends State<CartIconWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                size: 30, // Aumenta el tamaño del ícono aquí
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const CartSummaryWidget(),
                );
              },
            ),
            if (appState.cartItems.isNotEmpty)
              Positioned(
                right: 0,
                top: 20,
                child: Container(
                  padding: const EdgeInsets.all(
                      2), // Aumenta el padding para un círculo más grande
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(
                        10), // Aumenta la curvatura del borde
                  ),
                  constraints: const BoxConstraints(
                    minWidth:
                        24, // Aumenta el ancho mínimo para un contador más grande
                    minHeight:
                        24, // Aumenta el alto mínimo para un contador más grande
                  ),
                  child: Text(
                    '${appState.cartItems.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14, // Aumenta el tamaño de la fuente aquí
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
