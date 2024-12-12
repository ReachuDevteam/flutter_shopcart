import 'package:demo2/conts/data.dart';
import 'package:demo2/graphql/mutations/cartItems_mutations.dart';
import 'package:demo2/graphql/mutations/checkout_mutations.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  bool _sameAsBillingAddress = true;
  bool _acceptsTerms = true;
  bool _acceptsPurchaseConditions = true;

  String? _selectedBillingCountryCode;
  String? _selectedShippingCountryCode;

  Map<String, dynamic> billingAddress = {};
  Map<String, dynamic> shippingAddress = {};

  Map<String, TextEditingController> billingControllers = {};
  Map<String, TextEditingController> shippingControllers = {};

  @override
  void initState() {
    super.initState();
    _loadInitialState();
    _initBillingControllers();
    _initShippingControllers();
  }

  void _loadInitialState() {
    AppState appState = Provider.of<AppState>(context, listen: false);

    if (appState.checkoutState.isNotEmpty) {
      email = appState.checkoutState['email'] ?? '';
      billingAddress = appState.checkoutState['billingAddress'] ?? {};
      shippingAddress = appState.checkoutState['shippingAddress'] ?? {};
      _sameAsBillingAddress =
          appState.checkoutState['sameAsBillingAddress'] ?? false;
      _selectedBillingCountryCode = billingAddress['country_code'];
      _selectedShippingCountryCode = shippingAddress['country_code'];
    } else {
      _selectedBillingCountryCode = appState.selectedCountry;
      _selectedShippingCountryCode = appState.selectedCountry;

      billingAddress = Map.from(countriesMock[_selectedBillingCountryCode]!);
      shippingAddress = Map.from(countriesMock[_selectedShippingCountryCode]!);
    }
  }

  void _initBillingControllers() {
    billingControllers.clear();
    for (var key in billingAddress.keys) {
      if (key != 'country_code' && key != 'province_code') {
        billingControllers[key] =
            TextEditingController(text: billingAddress[key]);
      }
    }
    setState(() {});
  }

  void _initShippingControllers() {
    shippingControllers.clear();
    for (var key in shippingAddress.keys) {
      if (key != 'country_code' && key != 'province_code') {
        shippingControllers[key] =
            TextEditingController(text: shippingAddress[key]);
      }
    }
    setState(() {});
  }

  void _onCountryChanged(
      String? countryCode, Map<String, dynamic> address, String type) {
    setState(() {
      if (type == 'billing') {
        _selectedBillingCountryCode = countryCode;
        billingAddress = Map.from(countriesMock[countryCode]!);
        if (_sameAsBillingAddress) {
          shippingAddress = Map.from(billingAddress);
          _selectedShippingCountryCode = countryCode;
        }
        _initBillingControllers();
        if (_sameAsBillingAddress) {
          _initShippingControllers();
        }
      } else {
        _selectedShippingCountryCode = countryCode;
        shippingAddress = Map.from(countriesMock[countryCode]!);
        _initShippingControllers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildAddressSection('Billing Address', billingAddress,
                    _selectedBillingCountryCode, 'billing'),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text(
                      "Shipping address is the same as billing address"),
                  value: _sameAsBillingAddress,
                  onChanged: (value) {
                    setState(() {
                      _sameAsBillingAddress = value ?? true;
                      if (_sameAsBillingAddress) {
                        shippingAddress = Map.from(billingAddress);
                        _selectedShippingCountryCode =
                            _selectedBillingCountryCode;
                        _initShippingControllers();
                      }
                    });
                  },
                ),
                if (!_sameAsBillingAddress)
                  _buildAddressSection('Shipping Address', shippingAddress,
                      _selectedShippingCountryCode, 'shipping'),
                const SizedBox(height: 16),
                const SizedBox(
                    height: 20), // Additional space before the instruction text
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Please make sure to read and accept the following conditions:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                CheckboxListTile(
                  title: const Text("Accept Terms and Conditions"),
                  value: _acceptsTerms,
                  onChanged: null, // Disables interaction
                  controlAffinity: ListTileControlAffinity.leading,
                  secondary: Icon(Icons
                      .lock_outline), // Optional: adds a lock icon to signify locked state
                  activeColor:
                      Colors.grey, // Dim color to indicate disabled state
                  checkColor: Colors.white,
                  tileColor: Colors.grey[
                      200], // Optional: background color to enhance disabled visual
                ),
                CheckboxListTile(
                  title: const Text("Accept Purchase Conditions"),
                  value: _acceptsPurchaseConditions,
                  onChanged: null, // Disables interaction
                  controlAffinity: ListTileControlAffinity.leading,
                  secondary: Icon(Icons
                      .lock_outline), // Optional: adds a lock icon to signify locked state
                  activeColor:
                      Colors.grey, // Dim color to indicate disabled state
                  checkColor: Colors.white,
                  tileColor: Colors.grey[
                      200], // Optional: background color to enhance disabled visual
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit Order'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact Information',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Email'),
          initialValue: email,
          onSaved: (value) => email = value ?? '',
          validator: (value) =>
              value == null || value.isEmpty ? 'Field is required' : null,
        ),
      ],
    );
  }

  Widget _buildAddressSection(String title, Map<String, dynamic> address,
      String? selectedCountryCode, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        DropdownButtonFormField<String>(
          value: selectedCountryCode,
          decoration: const InputDecoration(labelText: 'Country'),
          items: countriesMock.entries
              .map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value['country']),
                ),
              )
              .toList(),
          onChanged: (value) => _onCountryChanged(value, address, type),
        ),
        ..._buildDynamicFields(address, type),
      ],
    );
  }

  List<Widget> _buildDynamicFields(Map<String, dynamic> address, String type) {
    final controllers =
        type == 'billing' ? billingControllers : shippingControllers;
    return address.keys
        .where((key) => key != 'country_code' && key != 'province_code')
        .map(
          (key) => TextFormField(
            controller: controllers[key],
            decoration: InputDecoration(labelText: key.replaceAll('_', ' ')),
            onSaved: (value) => address[key] = value ?? '',
          ),
        )
        .toList();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AppState appState = Provider.of<AppState>(context, listen: false);
      final GraphQLClient client = GraphQLProvider.of(context).value;
      final selectedShipping = appState.selectedShippingForItems;

      for (var entry in selectedShipping.entries) {
        final itemId = entry.key;
        final shippingId = entry.value;

        await CartItemMutations.updateItemToCart(
          client,
          appState.cartId,
          itemId,
          shippingId: shippingId,
        );
      }

      final checkoutResponse =
          await CheckoutMutations.createCheckout(client, appState.cartId);

      await CheckoutMutations.updateCheckout(
          client,
          checkoutResponse?["id"],
          email,
          billingAddress,
          shippingAddress,
          this._acceptsTerms,
          this._acceptsPurchaseConditions);

      appState.setCheckoutState({
        "id": checkoutResponse?["id"],
        'email': email,
        'billingAddress': billingAddress,
        'shippingAddress': shippingAddress,
        'sameAsBillingAddress': _sameAsBillingAddress,
        "totals": checkoutResponse?["totals"]
      });

      appState.setSelectedScreen(AppScreen.Payment);
    }
  }
}
