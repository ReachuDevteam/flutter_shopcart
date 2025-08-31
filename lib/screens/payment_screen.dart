import 'package:demo2/models/cartItem.dart';
import 'package:demo2/widgets/klarna_widget.dart';
import 'package:demo2/widgets/stripe_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

enum PaymentProvider { klarna, stripe }

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
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold)),
            const Divider(),
            ...info.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text("${entry.key}: ${entry.value}",
                    style: const TextStyle(fontSize: 16.0)),
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
    final total = _calculateTotalPrice(appState.cartItems);
    final currency = _getCurrency(appState.cartItems);

    final email = checkoutState['email'] ?? 'No email provided';
    final billing = checkoutState['billingAddress'] ?? const {};
    final shipping = checkoutState['shippingAddress'] ?? const {};

    final billingAddressInfo = {
      "Name": "${billing['first_name']} ${billing['last_name']}",
      "Phone": billing['phone'],
      "Address": "${billing['address1']}, ${billing['address2']}",
      "City": billing['city'],
      "Zip": billing['zip'],
      "Country": billing['country'],
    };

    final shippingAddressInfo = {
      "Name": "${shipping['first_name']} ${shipping['last_name']}",
      "Phone": shipping['phone'],
      "Address": "${shipping['address1']}, ${shipping['address2']}",
      "City": shipping['city'],
      "Zip": shipping['zip'],
      "Country": shipping['country'],
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
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold)),
            buildInfoCard("Billing Address", billingAddressInfo),
            buildInfoCard("Shipping Address", shippingAddressInfo),
            const SizedBox(height: 20),
            const Text('Select Payment Provider:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            ListTile(
              title: const Text('Klarna'),
              leading: Radio<PaymentProvider>(
                value: PaymentProvider.klarna,
                groupValue: _selectedProvider,
                onChanged: (PaymentProvider? value) {
                  setState(() => _selectedProvider = value);
                },
              ),
            ),
            ListTile(
              title: const Text('Stripe'),
              leading: Radio<PaymentProvider>(
                value: PaymentProvider.stripe,
                groupValue: _selectedProvider,
                onChanged: (PaymentProvider? value) {
                  setState(() => _selectedProvider = value);
                },
              ),
            ),
            if (_selectedProvider == PaymentProvider.stripe)
              StripePaymentCardWidget(
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

  double _calculateTotalPrice(List<CartItem> cartItems) {
    double totalPrice = 0.0;
    for (var item in cartItems) {
      totalPrice += item.quantity * item.unitPrice;
    }
    return totalPrice;
  }

  String _getCurrency(List<CartItem> cartItems) {
    return cartItems.isNotEmpty ? cartItems.first.currency : '';
  }
}
