import 'package:demo2/graphql/mutations/checkout_mutations.dart';
import 'package:demo2/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
    AppState appState = Provider.of<AppState>(context, listen: false);
    final GraphQLClient client = GraphQLProvider.of(context).value;

    final email = widget.email;
    final paymentMethod = "Stripe";
    final successUrl = "https://example.com/success";
    String checkoutId = appState.checkoutState['id'];

    try {
      final result = await CheckoutMutations.checkoutPaymentIntentStripe(
        client,
        email,
        paymentMethod,
        successUrl,
        checkoutId,
      );

      if (result != null) {
        final clientSecret = result['client_secret'];
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'Demo Shop',
          ),
        );
      } else {
        print("No se pudo obtener el clientSecret");
      }
    } catch (e) {
      print("Error al inicializar el PaymentSheet: $e");
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
    }
  }

  Widget paymentStatusWidget() {
    if (paymentSuccess == null) return SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(16),
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
          SizedBox(width: 10),
          Text(
            paymentSuccess! ? "Successful payment" : "Failed payment",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              // Asegura la inicialización antes de presentar el PaymentSheet
              await initPaymentSheet();
              // Presenta el PaymentSheet al usuario
              await presentPaymentSheet();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            child: Text(
                'Pay ${widget.currency} ${widget.totalAmount.toStringAsFixed(2)}'),
          ),
          SizedBox(height: 20),
          paymentStatusWidget(),
        ],
      ),
    );
  }
}
