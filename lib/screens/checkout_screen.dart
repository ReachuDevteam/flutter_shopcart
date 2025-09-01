import 'package:demo2/conts/data.dart';
import 'package:demo2/services/sdk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  static const Map<String, dynamic> _MOCK_CHECKOUT = {
    'email': 'demo@acme.test',
    'billingAddress': {
      'first_name': 'Ola',
      'last_name': 'Nordmann',
      'phone': '41234567',
      'phoneCode': '47',
      'address1': 'Karl Johans gate 1',
      'address2': 'Suite 2',
      'city': 'Oslo',
      'country': 'Norway',
      'countryCode': 'NO',
      'province': '',
      'provinceCode': '',
      'zip': '0154',
      'company': 'ACME AS',
    },
  };

  String _toKey(String? code) => (code ?? 'no').toLowerCase();
  String _toCode(String? key) => (key ?? 'no').toUpperCase();

  String email = '';
  Map<String, dynamic> billingAddress = {
    'first_name': '',
    'last_name': '',
    'phone': '',
    'phoneCode': '',
    'address1': '',
    'address2': '',
    'city': '',
    'country': '',
    'countryCode': '',
    'province': '',
    'provinceCode': '',
    'zip': '',
    'company': '',
  };
  Map<String, dynamic> shippingAddress = {};
  bool _sameAsBillingAddress = true;
  String? _selectedCountryCode;
  String? _selectedState;
  bool _showStateField = true;
  bool _acceptsTerms = true;
  bool _acceptsPurchaseConditions = true;

  final Map<String, dynamic> countriesData = {
    'no': {
      'name': 'Norway',
      'flag': 'assets/images/flags/no.png',
      'states': <String>[],
      'hasStates': false,
      'phoneCode': '+47',
    },
  };

  @override
  void initState() {
    super.initState();
    _loadInitialState();
  }

  void _loadInitialState() {
    final appState = Provider.of<AppState>(context, listen: false);

    if (appState.checkoutState.isNotEmpty) {
      email = appState.checkoutState['email'] ?? '';
      billingAddress = Map<String, dynamic>.from(
        (appState.checkoutState['billingAddress'] ?? {}) as Map,
      );
      shippingAddress = Map<String, dynamic>.from(
        (appState.checkoutState['shippingAddress'] ?? {}) as Map? ?? {},
      );
      _sameAsBillingAddress =
          appState.checkoutState['sameAsBillingAddress'] ?? true;

      _selectedCountryCode = _toKey(billingAddress['countryCode'] as String?);
    } else {
      final mockBilling =
          Map<String, dynamic>.from(_MOCK_CHECKOUT['billingAddress'] as Map);
      final mockShipping = Map<String, dynamic>.from(mockBilling);
      email = _MOCK_CHECKOUT['email'] as String;
      billingAddress = mockBilling;
      shippingAddress = mockShipping;
      _sameAsBillingAddress = true;

      _selectedCountryCode = _toKey(mockBilling['countryCode'] as String?);
    }

    _showStateField =
        countriesData[_selectedCountryCode]?['hasStates'] ?? false;

    _selectedState =
        (billingAddress['provinceCode']?.toString().isNotEmpty ?? false)
            ? billingAddress['provinceCode'] as String
            : null;

    setState(() {});
  }

  void _onCountryChanged(String? countryKey) {
    final key = _toKey(countryKey);
    setState(() {
      _selectedCountryCode = key;
      _showStateField = countriesData[key]?['hasStates'] ?? false;

      billingAddress['countryCode'] = _toCode(key);
      shippingAddress['countryCode'] = _toCode(key);

      billingAddress['country'] = countriesData[key]?['name'];
      shippingAddress['country'] = countriesData[key]?['name'];

      _selectedState = countriesData[key]?['states']?.isNotEmpty == true
          ? (countriesData[key]!['states'] as List).first.toString()
          : null;

      billingAddress['province'] = _selectedState ?? '';
      billingAddress['provinceCode'] = _selectedState ?? '';
      shippingAddress['province'] = _selectedState ?? '';
      shippingAddress['provinceCode'] = _selectedState ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Contact Information',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  initialValue: email,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please enter your email'
                      : null,
                  onSaved: (value) => email = value ?? '',
                ),
                const SizedBox(height: 16),
                Text('Billing Address',
                    style: Theme.of(context).textTheme.titleLarge),
                _buildAddressFields('billing'),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text(
                      "Shipping address is the same as billing address"),
                  value: _sameAsBillingAddress,
                  onChanged: (bool? value) =>
                      setState(() => _sameAsBillingAddress = value ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                if (!_sameAsBillingAddress) ...[
                  Text('Shipping Address',
                      style: Theme.of(context).textTheme.titleLarge),
                  _buildAddressFields('shipping'),
                ],
                const SizedBox(height: 20),
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
                  onChanged: null,
                  controlAffinity: ListTileControlAffinity.leading,
                  secondary: const Icon(Icons.lock_outline),
                  activeColor: Colors.grey,
                  checkColor: Colors.white,
                  tileColor: Colors.grey[200],
                ),
                CheckboxListTile(
                  title: const Text("Accept Purchase Conditions"),
                  value: _acceptsPurchaseConditions,
                  onChanged: null,
                  controlAffinity: ListTileControlAffinity.leading,
                  secondary: const Icon(Icons.lock_outline),
                  activeColor: Colors.grey,
                  checkColor: Colors.white,
                  tileColor: Colors.grey[200],
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

  Widget _buildAddressFields(String type) {
    final addr = type == 'billing' ? billingAddress : shippingAddress;

    return Column(
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(labelText: 'First Name'),
          initialValue: (addr['first_name'] ?? '') as String,
          onSaved: (v) => type == 'billing'
              ? billingAddress['first_name'] = v ?? ''
              : shippingAddress['first_name'] = v ?? '',
          validator: (v) => v == null || v.isEmpty ? 'Field is required' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Last Name'),
          initialValue: (addr['last_name'] ?? '') as String,
          onSaved: (v) => type == 'billing'
              ? billingAddress['last_name'] = v ?? ''
              : shippingAddress['last_name'] = v ?? '',
          validator: (v) => v == null || v.isEmpty ? 'Field is required' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Phone'),
          initialValue: (addr['phone'] ?? '') as String,
          onSaved: (v) => type == 'billing'
              ? billingAddress['phone'] = v ?? ''
              : shippingAddress['phone'] = v ?? '',
          validator: (v) => v == null || v.isEmpty ? 'Field is required' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Address Line 1'),
          initialValue: (addr['address1'] ?? '') as String,
          onSaved: (v) => type == 'billing'
              ? billingAddress['address1'] = v ?? ''
              : shippingAddress['address1'] = v ?? '',
          validator: (v) => v == null || v.isEmpty ? 'Field is required' : null,
        ),
        TextFormField(
          decoration:
              const InputDecoration(labelText: 'Address Line 2 (Optional)'),
          initialValue: (addr['address2'] ?? '') as String,
          onSaved: (v) => type == 'billing'
              ? billingAddress['address2'] = v ?? ''
              : shippingAddress['address2'] = v ?? '',
        ),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Country'),
          value: _selectedCountryCode ?? 'no',
          onChanged: _onCountryChanged,
          items: countriesData.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Row(
                children: [
                  Image.asset(entry.value['flag'], width: 30, height: 20),
                  const SizedBox(width: 8),
                  Text(entry.value['name']),
                ],
              ),
            );
          }).toList(),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'City'),
          initialValue: (addr['city'] ?? '') as String,
          onSaved: (v) => type == 'billing'
              ? billingAddress['city'] = v ?? ''
              : shippingAddress['city'] = v ?? '',
          validator: (v) => v == null || v.isEmpty ? 'Field is required' : null,
        ),
        if (_showStateField)
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'State/Province'),
            value: _selectedState,
            onChanged: (String? newValue) {
              setState(() {
                _selectedState = newValue;
                if (type == 'billing') {
                  billingAddress['province'] = newValue ?? '';
                  billingAddress['provinceCode'] = newValue ?? '';
                } else {
                  shippingAddress['province'] = newValue ?? '';
                  shippingAddress['provinceCode'] = newValue ?? '';
                }
              });
            },
            items: (_selectedCountryCode != null &&
                    countriesData[_selectedCountryCode] != null &&
                    (countriesData[_selectedCountryCode]['states']
                                as List<dynamic>?)
                            ?.isNotEmpty ==
                        true)
                ? (countriesData[_selectedCountryCode]['states']
                        as List<dynamic>)
                    .map<DropdownMenuItem<String>>((state) {
                    return DropdownMenuItem<String>(
                      value: state.toString(),
                      child: Text(state.toString()),
                    );
                  }).toList()
                : const [],
          ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'ZIP/Postal Code'),
          initialValue: (addr['zip'] ?? '') as String,
          onSaved: (v) => type == 'billing'
              ? billingAddress['zip'] = v ?? ''
              : shippingAddress['zip'] = v ?? '',
          validator: (v) => v == null || v.isEmpty ? 'Field is required' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Company (Optional)'),
          initialValue: (addr['company'] ?? '') as String,
          onSaved: (v) => type == 'billing'
              ? billingAddress['company'] = v ?? ''
              : shippingAddress['company'] = v ?? '',
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    final appState = Provider.of<AppState>(context, listen: false);
    final sdk = SdkService().sdk;

    try {
      final selectedCountryCode = (appState.checkoutState['billingAddress']
                  ?['countryCode'] ??
              _selectedCountryCode ??
              COUNTRY_INIT)
          .toString()
          .toUpperCase();

      final selectedPhoneCode =
          countriesData[selectedCountryCode.toLowerCase()]['phoneCode'];
      final selectedCountryName =
          countriesData[selectedCountryCode.toLowerCase()]['name'];

      final emailFinal = (appState.checkoutState['email'] as String?) ?? email;

      final billing = formatAddressForMutation(
        appState.checkoutState.containsKey('billingAddress')
            ? appState.checkoutState['billingAddress']
            : billingAddress,
        emailFinal,
        selectedPhoneCode,
        selectedCountryName,
      );

      final shipping = _sameAsBillingAddress
          ? billing
          : formatAddressForMutation(
              appState.checkoutState.containsKey('shippingAddress')
                  ? appState.checkoutState['shippingAddress']
                  : shippingAddress,
              emailFinal,
              selectedPhoneCode,
              selectedCountryName,
            );

      final created = await sdk.checkout.create(cart_id: appState.cartId);

      await sdk.checkout.update(
        checkout_id: created.id,
        email: emailFinal,
        billing_address: billing,
        shipping_address: shipping,
        buyer_accepts_purchase_conditions: _acceptsTerms,
        buyer_accepts_terms_conditions: _acceptsPurchaseConditions,
        payment_method: 'Klarna',
      );

      appState.setCheckoutState({
        'id': created.id,
        'email': emailFinal,
        'billingAddress': billing,
        'shippingAddress': shipping,
        'sameAsBillingAddress': _sameAsBillingAddress,
      });

      appState.setSelectedScreen(AppScreen.Payment);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checkout error: $e')),
      );
    }
  }

  Map<String, dynamic> formatAddressForMutation(
    Map<String, dynamic> address,
    String email,
    String phoneCode,
    String country,
  ) {
    return {
      'address1': address['address1'],
      'address2': address['address2'],
      'city': address['city'],
      'company': address['company'],
      'country': country,
      'country_code': (address['countryCode'] as String).toUpperCase(),
      'email': email,
      'first_name': address['first_name'],
      'last_name': address['last_name'],
      'phone': address['phone'],
      'phone_code': phoneCode,
      'province': address['province'],
      'province_code': address['provinceCode'],
      'zip': address['zip'],
    };
  }
}
