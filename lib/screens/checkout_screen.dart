import 'package:demo2/conts/data.dart';
import 'package:demo2/graphql/mutations/cartItems_mutations.dart';
import 'package:demo2/graphql/mutations/cart_mutations.dart';
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
    // 'us': {
    //   'name': 'United States',
    //   'flag': 'assets/images/flags/us.png',
    //   'states': ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix'],
    //   'hasStates': true, // Estados Unidos tiene estados
    // 'phoneCode': '+1',

    // },
    'no': {
      'name': 'Norway',
      'flag': 'assets/images/flags/no.png',
      'states': [],
      'hasStates':
          false, // Noruega no tiene estados en el mismo sentido que EE.UU.
      'phoneCode': '+47',
    },
    // 'gb': {
    //   'name': 'United Kingdom',
    //   'flag': 'assets/images/flags/gb.png',
    //   'states': ['London', 'Edinburgh', 'Manchester', 'Birmingham', 'Glasgow'],
    //   'hasStates':
    //       false, // El Reino Unido tiene regiones, pero no estados en el sentido tradicional
    // 'phoneCode': '+44',

    // },
    // 'ca': {
    //   'name': 'Canada',
    //   'flag': 'assets/images/flags/ca.png',
    //   'states': ['Toronto', 'Montreal', 'Vancouver', 'Calgary', 'Edmonton'],
    //   'hasStates': true, // Canadá tiene provincias
    // 'phoneCode': '+1',

    // },
    // 'fr': {
    //   'name': 'France',
    //   'flag': 'assets/images/flags/fr.png',
    //   'states': ['Paris', 'Marseille', 'Lyon', 'Toulouse', 'Nice'],
    //   'hasStates':
    //       false, // Francia se divide en regiones, pero no se utiliza el término "estados"
    // 'phoneCode': '+33',

    // },
    // 'de': {
    //   'name': 'Germany',
    //   'flag': 'assets/images/flags/de.png',
    //   'states': ['Berlin', 'Munich', 'Frankfurt', 'Hamburg', 'Cologne'],
    //   'hasStates': true, // Alemania tiene estados, conocidos como "Länder"
    // 'phoneCode': '+49',

    // },
    // 'jp': {
    //   'name': 'Japan',
    //   'flag': 'assets/images/flags/jp.png',
    //   'states': ['Tokyo', 'Osaka', 'Yokohama', 'Nagoya', 'Sapporo'],
    //   'hasStates':
    //       true, // Japón tiene prefecturas, que son equivalentes a estados
    // 'phoneCode': '+81',

    // },
    // 'cn': {
    //   'name': 'China',
    //   'flag': 'assets/images/flags/cn.png',
    //   'states': ['Beijing', 'Shanghai', 'Chengdu', 'Guangzhou', 'Shenzhen'],
    //   'hasStates': true, // China tiene provincias
    // 'phoneCode': '+86',

    // },
    // 'br': {
    //   'name': 'Brazil',
    //   'flag': 'assets/images/flags/br.png',
    //   'states': [
    //     'São Paulo',
    //     'Rio de Janeiro',
    //     'Salvador',
    //     'Brasília',
    //     'Fortaleza'
    //   ],
    //   'hasStates': true, // Brasil tiene estados
    // 'phoneCode': '+55',

    // },
    // 'it': {
    //   'name': 'Italy',
    //   'flag': 'assets/images/flags/it.png',
    //   'states': ['Rome', 'Milan', 'Naples', 'Turin', 'Palermo'],
    //   'hasStates':
    //       false, // Italia se divide en regiones, pero no se utiliza el término "estados"
    // 'phoneCode': '+39',

    // },
  };

  @override
  void initState() {
    super.initState();
    _loadInitialState();
  }

  void _loadInitialState() {
    AppState appState = Provider.of<AppState>(context, listen: false);
    if (appState.checkoutState.isNotEmpty) {
      setState(() {
        email = appState.checkoutState['email'] ?? '';
        billingAddress = appState.checkoutState['billingAddress'] ?? {};
        shippingAddress = appState.checkoutState['shippingAddress'] ?? {};
        _sameAsBillingAddress =
            appState.checkoutState['sameAsBillingAddress'] ?? false;
        _selectedCountryCode = billingAddress['countryCode'];
      });
    } else {
      setState(() {
        _selectedCountryCode = appState.selectedCountry;
        billingAddress['countryCode'] = appState.selectedCountry;
        shippingAddress['countryCode'] = appState.selectedCountry;
      });
    }
    _showStateField = countriesData[_selectedCountryCode]?['hasStates'] ?? true;
    _selectedState =
        countriesData[_selectedCountryCode]?['states']?.isNotEmpty == true
            ? countriesData[_selectedCountryCode]['states'][0]
            : null;
  }

  void _onCountryChanged(String? countryCode) {
    setState(() {
      _selectedCountryCode = countryCode;
      _showStateField = countriesData[countryCode]?['hasStates'] ?? true;
      billingAddress['countryCode'] = countryCode;
      shippingAddress['countryCode'] = countryCode;

      billingAddress['country'] = countriesData[countryCode]?['name'];
      shippingAddress['country'] = countriesData[countryCode]?['name'];

      // Reset the selected city as the country has changed.
      _selectedState = countriesData[countryCode]?['states']?.isNotEmpty == true
          ? countriesData[countryCode]['states'][0]
          : null;
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
              children: <Widget>[
                Text('Contact Information',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
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
                  onChanged: (bool? value) {
                    setState(() {
                      _sameAsBillingAddress = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                if (!_sameAsBillingAddress) ...[
                  Text('Shipping Address',
                      style: Theme.of(context).textTheme.titleLarge),
                  _buildAddressFields('shipping'),
                ],

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

  Widget _buildAddressFields(String type) {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(labelText: 'First Name'),
          onSaved: (value) => type == 'billing'
              ? billingAddress['first_name'] = value ?? ''
              : shippingAddress['first_name'] = value ?? '',
          validator: (value) =>
              value == null || value.isEmpty ? 'Field is required' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Last Name'),
          onSaved: (value) => type == 'billing'
              ? billingAddress['last_name'] = value ?? ''
              : shippingAddress['last_name'] = value ?? '',
          validator: (value) =>
              value == null || value.isEmpty ? 'Field is required' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Phone'),
          onSaved: (value) => type == 'billing'
              ? billingAddress['phone'] = value ?? ''
              : shippingAddress['phone'] = value ?? '',
          validator: (value) =>
              value == null || value.isEmpty ? 'Field is required' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Address Line 1'),
          onSaved: (value) => type == 'billing'
              ? billingAddress['address1'] = value ?? ''
              : shippingAddress['address1'] = value ?? '',
          validator: (value) =>
              value == null || value.isEmpty ? 'Field is required' : null,
        ),
        TextFormField(
          decoration:
              const InputDecoration(labelText: 'Address Line 2 (Optional)'),
          onSaved: (value) => type == 'billing'
              ? billingAddress['address2'] = value ?? ''
              : shippingAddress['address2'] = value ?? '',
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
                  SizedBox(width: 8),
                  Text(entry.value['name']),
                ],
              ),
            );
          }).toList(),
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'City'),
          onSaved: (value) => billingAddress['city'] = value ?? '',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Field is required';
            }
            return null;
          },
        ),
        if (_showStateField)
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'State/Province'),
            value: _selectedState,
            onChanged: (String? newValue) {
              setState(() => _selectedState = newValue);
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
                : [],
          ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'ZIP/Postal Code'),
          onSaved: (value) => type == 'billing'
              ? billingAddress['zip'] = value ?? ''
              : shippingAddress['zip'] = value ?? '',
          validator: (value) =>
              value == null || value.isEmpty ? 'Field is required' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Company (Optional)'),
          onSaved: (value) => type == 'billing'
              ? billingAddress['company'] = value ?? ''
              : shippingAddress['company'] = value ?? '',
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AppState appState = Provider.of<AppState>(context, listen: false);
      final GraphQLClient client = GraphQLProvider.of(context).value;

      // Uses the ?? operator to fall back to the form values if checkoutState does not have the necessary data.
      final email =
          appState.checkoutState['email'] as String? ?? this.email ?? '';
      final selectedCountryCode = appState.checkoutState['billingAddress']
              ?['countryCode'] ??
          _selectedCountryCode;
      final selectedPhoneCode = countriesData[selectedCountryCode]['phoneCode'];
      final selectedCountryName = countriesData[selectedCountryCode]['name'];

      Map<String, dynamic> billingAddress = formatAddressForMutation(
          appState.checkoutState.containsKey('billingAddress')
              ? appState.checkoutState['billingAddress']
              : this.billingAddress,
          email,
          selectedPhoneCode,
          selectedCountryName);

      // Determine the shipping address depending on whether it is the same as the billing address or not.
      Map<String, dynamic> shippingAddress;
      if (_sameAsBillingAddress) {
        shippingAddress = billingAddress;
      } else {
        final selectedCountryCode = appState.checkoutState['shippingAddress']
                ?['countryCode'] ??
            _selectedCountryCode;
        final selectedPhoneCode =
            countriesData[selectedCountryCode]['phoneCode'];
        final selectedCountryName = countriesData[selectedCountryCode]['name'];

        shippingAddress = formatAddressForMutation(
            appState.checkoutState.containsKey('shippingAddress')
                ? appState.checkoutState['shippingAddress']
                : this.shippingAddress,
            email,
            selectedPhoneCode, // Assuming that the shipping phone code is the same as the billing phone code
            selectedCountryName); // Assuming the country of shipment is the same as the billing country
      }

      // Update the cart mutation with the country of shipment.
      await CartMutations.executeUpdateCartMutation(
        client,
        cartId: appState.cartId,
        shippingCountry: selectedCountryCode.toUpperCase(),
      );

      // Iterate over the items in the cart and update them if necessary.
      for (var cartItem in appState.cartItems) {
        String? countryId = await findShippingCountryId(selectedCountryCode,
            appState.selectedCurrency, cartItem.productShipping);
        if (countryId != null) {
          await CartItemMutations.updateItemToCart(
            client,
            appState.cartId,
            cartItem.cartItemId,
            shippingId: countryId,
          );
        } else {
          print(
              'Country id could not be found for the cart item with id: ${cartItem.cartItemId}');
        }
      }

      final response =
          await CheckoutMutations.createCheckout(client, appState.cartId);

      await CheckoutMutations.updateCheckout(
          client,
          response?["id"],
          email,
          billingAddress,
          shippingAddress,
          this._acceptsTerms,
          this._acceptsPurchaseConditions);

      appState.setCheckoutState({
        "id": response?["id"],
        'email': email,
        'billingAddress': billingAddress,
        'shippingAddress': shippingAddress,
        'sameAsBillingAddress': _sameAsBillingAddress,
      });

      appState.setSelectedScreen(AppScreen.Payment);
    }
  }

  String? findShippingCountryId(
      String countryCode, String currencyCode, List<dynamic>? productShipping) {
    if (productShipping == null) {
      return null; // Return null if productShipping is null
    }

    for (var shippingInfo in productShipping) {
      var shippingCountries =
          shippingInfo['shipping_country'] as List<dynamic>?;
      if (shippingCountries != null) {
        for (var country in shippingCountries) {
          var countryInfo = country as Map<String, dynamic>?;
          if (countryInfo != null) {
            if (countryInfo['country'] == countryCode.toUpperCase() &&
                countryInfo['currency_code'] == currencyCode) {
              return countryInfo['id'] as String?;
            }
          }
        }
      }
    }
    return null; // Returns null if country id is not found
  }

  Map<String, dynamic> formatAddressForMutation(Map<String, dynamic> address,
      String email, String phoneCode, String country) {
    return {
      "address1": address['address1'],
      "address2": address['address2'],
      "city": address['city'],
      "company": address['company'],
      "country": country,
      "country_code": (address['countryCode'] as String).toUpperCase(),
      "email": email,
      "first_name": address['first_name'],
      "last_name": address['last_name'],
      "phone": address['phone'],
      "phone_code": phoneCode,
      "province": address['province'],
      "province_code": address['provinceCode'],
      "zip": address['zip'],
    };
  }
}
