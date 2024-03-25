import 'package:demo2/models/cartItem.dart';
import 'package:demo2/widgets/klarna_widget.dart';
import 'package:demo2/widgets/stripe_link_widget.dart';
import 'package:demo2/widgets/stripe_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

enum PaymentProvider { klarna, stripe, stripeLink }

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentProvider? _selectedProvider = PaymentProvider.klarna;

  Widget buildInfoCard(String title, Map<String, dynamic> info) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            Divider(),
            ...info.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text("${entry.key}: ${entry.value}",
                    style: TextStyle(fontSize: 16.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final checkoutState = appState.checkoutState;
    double total = calculateTotalPrice(appState.cartItems);
    String currency = getCurrency(appState.cartItems);

    final email = checkoutState['email'] ?? 'No email provided';
    final billingAddressInfo = {
      "Name":
          "${checkoutState['billingAddress']['first_name']} ${checkoutState['billingAddress']['last_name']}",
      "Phone": checkoutState['billingAddress']['phone'],
      "Address":
          "${checkoutState['billingAddress']['address1']}, ${checkoutState['billingAddress']['address2']}",
      "City": checkoutState['billingAddress']['city'],
      "Zip": checkoutState['billingAddress']['zip'],
      "Country": checkoutState['billingAddress']['country']
    };

    final shippingAddressInfo = {
      "Name":
          "${checkoutState['shippingAddress']['first_name']} ${checkoutState['shippingAddress']['last_name']}",
      "Phone": checkoutState['shippingAddress']['phone'],
      "Address":
          "${checkoutState['shippingAddress']['address1']}, ${checkoutState['shippingAddress']['address2']}",
      "City": checkoutState['shippingAddress']['city'],
      "Zip": checkoutState['shippingAddress']['zip'],
      "Country": checkoutState['shippingAddress']['country']
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact Email: $email',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            buildInfoCard("Billing Address", billingAddressInfo),
            buildInfoCard("Shipping Address", shippingAddressInfo),
            SizedBox(height: 20),
            Text('Select Payment Provider:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            ListTile(
              title: const Text('Klarna'),
              leading: Radio<PaymentProvider>(
                value: PaymentProvider.klarna,
                groupValue: _selectedProvider,
                onChanged: (PaymentProvider? value) {
                  setState(() {
                    _selectedProvider = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Stripe'),
              leading: Radio<PaymentProvider>(
                value: PaymentProvider.stripe,
                groupValue: _selectedProvider,
                onChanged: (PaymentProvider? value) {
                  setState(() {
                    _selectedProvider = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Stripe Link'),
              leading: Radio<PaymentProvider>(
                value: PaymentProvider.stripeLink,
                groupValue: _selectedProvider,
                onChanged: (PaymentProvider? value) {
                  setState(() {
                    _selectedProvider = value;
                  });
                },
              ),
            ),
            if (_selectedProvider == PaymentProvider.stripe)
              StripePaymentCardWidget(
                email: email,
                currency: currency,
                totalAmount: total,
              ),
            if (_selectedProvider == PaymentProvider.stripeLink)
              StripeLinkPaymentCardWidget(
                email: email,
                currency: currency,
                totalAmount: total,
              ),
            if (_selectedProvider == PaymentProvider.klarna)
              KlarnaPaymentCardWidget(
                email: email,
                currency: currency,
                totalAmount: total,
              ),
          ],
        ),
      ),
    );
  }

  double calculateTotalPrice(List<CartItem> cartItems) {
    double totalPrice = 0.0;

    // Add the total price of all products in the cart
    for (var item in cartItems) {
      totalPrice += item.quantity * item.unitPrice;
    }

    return totalPrice;
  }

  String getCurrency(List<CartItem> cartItems) {
    //  Gets the currency of the first item in the cartItems list
    if (cartItems.isNotEmpty) {
      return cartItems.first.currency;
    } else {
      return ''; // If there are no items in the cart, returns an empty string.
    }
  }
}
