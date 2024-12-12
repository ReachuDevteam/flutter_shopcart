import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../graphql/queries/cart_queries.dart';
import '../models/cartSupplierLineItems.dart';
import '../state/app_state.dart';

class ShippingListScreen extends StatefulWidget {
  const ShippingListScreen({super.key});

  @override
  _ShippingListScreenState createState() => _ShippingListScreenState();
}

class _ShippingListScreenState extends State<ShippingListScreen> {
  late Future<List<CartSupplierLineItems>> _shippingFuture;

  @override
  void initState() {
    super.initState();
    _shippingFuture = Future.value([]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadShippingData();
    });
  }

  void _loadShippingData() {
    final GraphQLClient client = GraphQLProvider.of(context).value;
    final AppState appState = Provider.of<AppState>(context, listen: false);

    appState.clearShippingSelections();

    setState(() {
      _shippingFuture = CartQueries.executeGetLineItemsBySupplierQueryQuery(
        client,
        appState.cartId,
        fetchPolicy: FetchPolicy.networkOnly,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Options'),
      ),
      body: FutureBuilder<List<CartSupplierLineItems>>(
        key: ValueKey(_shippingFuture),
        future: _shippingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child:
                    Text('Error fetching shipping options: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final suppliers = snapshot.data!;

            // Caso de un solo proveedor
            if (suppliers.length == 1) {
              final supplier = suppliers.first;
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  ...supplier.availableShippings.map((shipping) {
                    return RadioListTile<String>(
                      value: shipping.id,
                      groupValue: appState
                          .getShippingForItem(supplier.lineItems.first.id),
                      onChanged: (value) {
                        setState(() {
                          final itemIds = supplier.lineItems
                              .map((item) => item.id)
                              .toList();
                          appState.updateShippingForSupplier(itemIds, value!);
                        });
                      },
                      title: Text(shipping.name),
                      subtitle: Text(shipping.description),
                      secondary: Text(
                        '${shipping.price.amount.toStringAsFixed(2)} ${shipping.price.currencyCode}',
                      ),
                    );
                  }).toList(),
                ],
              );
            }

            // Caso de múltiples proveedores
            return ListView.builder(
              itemCount: suppliers.length,
              itemBuilder: (context, index) {
                final supplier = suppliers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Lista de productos
                        Column(
                          children: supplier.lineItems.map((item) {
                            return ListTile(
                              leading: item.images.isNotEmpty
                                  ? Image.network(item.images.first.url,
                                      width: 50, height: 50, fit: BoxFit.cover)
                                  : const Icon(Icons.image_not_supported),
                              title: Text(item.title),
                              subtitle: Text(item.barcode.isNotEmpty
                                  ? 'Barcode: ${item.barcode}'
                                  : 'SKU: ${item.sku}'),
                              trailing: Text(
                                '${item.price.amount.toStringAsFixed(2)} ${item.price.currencyCode}',
                              ),
                            );
                          }).toList(),
                        ),
                        const Divider(),
                        // Lista de shippings
                        Text(
                          'Shipping Options',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                        ...supplier.availableShippings.map((shipping) {
                          return RadioListTile<String>(
                            value: shipping.id,
                            groupValue: appState.getShippingForItem(
                                supplier.lineItems.first.id),
                            onChanged: (value) {
                              setState(() {
                                // Aplica el shipping seleccionado al supplier
                                final itemIds = supplier.lineItems
                                    .map((item) => item.id)
                                    .toList();
                                appState.updateShippingForSupplier(
                                    itemIds, value!);
                              });
                            },
                            title: Text(shipping.name),
                            subtitle: Text(shipping.description),
                            secondary: Text(
                              '${shipping.price.amount.toStringAsFixed(2)} ${shipping.price.currencyCode}',
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No shipping options available'));
          }
        },
      ),
    );
  }
}
