import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/sdk.dart';
import '../state/app_state.dart';

// Importa DTOs del SDK
import 'package:reachu_flutter_sdk/reachu_flutter_sdk.dart'
    show
        GetLineItemsBySupplierDto,
        SupplierLineItemsBySupplierDto,
        LineItemDto,
        LineItemAvailableShippingDto,
        PriceLineItemAvailableShippingDto;

class ShippingSelectionScreen extends StatefulWidget {
  const ShippingSelectionScreen({super.key});

  @override
  State<ShippingSelectionScreen> createState() =>
      _ShippingSelectionScreenState();
}

class _ShippingSelectionScreenState extends State<ShippingSelectionScreen> {
  bool _loading = true;
  bool _applying = false;

  // 👇 TIPADO correcto (no dynamic)
  List<GetLineItemsBySupplierDto> _groups = [];

  // Selección por supplierId
  final Map<int, String> _selectedShippingBySupplier = {};
  // cart_item_id -> shipping_id
  final Map<String, String> _shippingByCartItemId = {};

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final sdk = SdkService().sdk;

    setState(() => _loading = true);
    try {
      final res =
          await sdk.cart.getLineItemsBySupplier(cart_id: appState.cartId);
      setState(() {
        _groups = res; // List<GetLineItemsBySupplierDto>
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading shippings: $e')),
      );
    }
  }

  void _onSelectShippingForSupplier({
    required int supplierId,
    required String shippingId,
    required List<LineItemDto> lineItems,
  }) {
    _selectedShippingBySupplier[supplierId] = shippingId;
    for (final li in lineItems) {
      _shippingByCartItemId[li.id] = shippingId;
    }
    setState(() {});
  }

  Future<void> _applySelections() async {
    if (_shippingByCartItemId.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a shipping option.')),
      );
      return;
    }

    final appState = Provider.of<AppState>(context, listen: false);
    final sdk = SdkService().sdk;

    setState(() => _applying = true);
    try {
      for (final entry in _shippingByCartItemId.entries) {
        await sdk.cart.updateItem(
          cart_id: appState.cartId,
          cart_item_id: entry.key,
          shipping_id: entry.value,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shipping updated successfully.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error applying shippings: $e')),
      );
    } finally {
      if (mounted) setState(() => _applying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Shipping')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _groups.isEmpty
              ? const Center(child: Text('No items to ship'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _groups.length,
                        itemBuilder: (context, index) {
                          final group = _groups[index];

                          // ✅ DTO camelCase
                          final SupplierLineItemsBySupplierDto? supplier =
                              group.supplier;
                          final int supplierId = supplier?.id ?? 0;
                          final String supplierName =
                              supplier?.name ?? 'Unknown supplier';

                          final List<LineItemDto> items = group.lineItems;
                          final List<LineItemAvailableShippingDto> shippings =
                              group.availableShippings ?? const [];

                          final selectedShippingId =
                              _selectedShippingBySupplier[supplierId];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Supplier: $supplierName',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  const SizedBox(height: 8),

                                  // Resumen de items
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: items
                                        .map((li) => Chip(
                                              label: Text(
                                                '${li.title ?? 'Item'} • ${li.price.amount.toStringAsFixed(2)} ${li.price.currencyCode}',
                                              ),
                                            ))
                                        .toList(),
                                  ),

                                  const Divider(height: 24),

                                  // Radios de envíos disponibles
                                  if (shippings.isEmpty)
                                    const Text(
                                      'No available shippings for this supplier.',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  else
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Available Shippings:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 8),
                                        ...shippings.map((s) {
                                          final price = s.price;
                                          final labelPrice =
                                              _formatShippingPrice(
                                                  price, appState);
                                          return RadioListTile<String>(
                                            value: s.id ?? '',
                                            groupValue: selectedShippingId,
                                            onChanged: (value) {
                                              if (value == null ||
                                                  value.isEmpty) return;
                                              _onSelectShippingForSupplier(
                                                supplierId: supplierId,
                                                shippingId: value,
                                                lineItems: items,
                                              );
                                            },
                                            title: Text(s.name ?? 'Shipping'),
                                            subtitle: Text(
                                              '${s.description ?? ''}\n$labelPrice',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _applying ? null : _applySelections,
                            child: _applying
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    ),
                                  )
                                : const Text('Confirm Shippings'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  String _formatShippingPrice(
    PriceLineItemAvailableShippingDto price,
    AppState appState,
  ) {
    final curr = price.currencyCode ?? appState.selectedCurrency;
    final amt = price.amount ?? 0.0;
    return 'Price: ${amt.toStringAsFixed(2)} $curr';
  }
}
