import 'package:demo2/state/app_state.dart';
import 'package:demo2/services/sdk.dart'; // ✅ usa el SDK
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

class StripePaymentCardWidget extends StatefulWidget {
  final String email;
  final double totalAmount;
  final String currency;

  const StripePaymentCardWidget({
    Key? key,
    required this.email,
    required this.totalAmount,
    required this.currency,
  }) : super(key: key);

  @override
  State<StripePaymentCardWidget> createState() =>
      _StripePaymentCardWidgetState();
}

class _StripePaymentCardWidgetState extends State<StripePaymentCardWidget> {
  bool? paymentSuccess;

  @override
  void initState() {
    super.initState();
    Stripe.publishableKey = '${dotenv.env['STRIPE_PUBLISHABLE_KEY']}';
  }

  Future<void> initPaymentSheet() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final sdk = SdkService().sdk;

    final String checkoutId = appState.checkoutState['id'];

    try {
      // ✅ Migración: usamos el SDK en lugar de CheckoutMutations + GraphQL
      final intent = await sdk.payment.stripeIntent(
        checkoutId: checkoutId,
        returnEphemeralKey: true, // igual que antes
      );

      if (intent != null) {
        final clientSecret = intent.clientSecret;
        if (clientSecret == null || clientSecret.isEmpty) {
          throw Exception('Could not obtain the clientSecret');
        }
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'Demo Shop',
          ),
        );
      } else {
        // ignore: avoid_print
        print("Could not obtain the clientSecret");
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error when initializing the PaymentSheet: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Stripe init error: $e')),
        );
      }
    }
  }

  Future<void> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      setState(() {
        paymentSuccess = true;
      });
    } catch (e) {
      setState(() {
        paymentSuccess = false;
      });
      // ignore: avoid_print
      print("Error presenting PaymentSheet: $e");
    }
  }

  Widget paymentStatusWidget() {
    if (paymentSuccess == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: paymentSuccess! ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            paymentSuccess! ? Icons.check_circle_outline : Icons.error_outline,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 10),
          Text(
            paymentSuccess! ? "Successful payment" : "Failed payment",
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              // Ensures initialization before submitting the PaymentSheet
              await initPaymentSheet();
              // Presents the PaymentSheet to the user
              await presentPaymentSheet();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            child: Text(
                'Pay ${widget.currency} ${widget.totalAmount.toStringAsFixed(2)}'),
          ),
          const SizedBox(height: 20),
          paymentStatusWidget(),
        ],
      ),
    );
  }
}
