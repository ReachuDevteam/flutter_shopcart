import 'package:demo2/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:demo2/graphql/mutations/checkout_mutations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StripeLinkPaymentCardWidget extends StatefulWidget {
  final String email;
  final double totalAmount;
  final String currency;

  const StripeLinkPaymentCardWidget({
    Key? key,
    required this.email,
    required this.totalAmount,
    required this.currency,
  }) : super(key: key);

  @override
  _StripeLinkPaymentCardWidgetState createState() =>
      _StripeLinkPaymentCardWidgetState();
}

class _StripeLinkPaymentCardWidgetState
    extends State<StripeLinkPaymentCardWidget> {
  bool? paymentSuccess;
  String url = "";
  bool showWebView = false;
  int orderId = -1;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchStripeLinkSnippet() async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    final GraphQLClient client = GraphQLProvider.of(context).value;

    final email = widget.email;
    const paymentMethod = "Stripe";
    String checkoutId = appState.checkoutState['id'];

    try {
      var result = await CheckoutMutations.checkoutInitPaymentStripe(
        client,
        email,
        paymentMethod,
        dotenv.env['FAKE_RETURN_URL']!,
        checkoutId,
      );

      if (result != null && result["order_id"] != null) {
        setState(() {
          orderId = result["order_id"];
          url = result["checkout_url"];
        });

        setState(() {
          showWebView = true;
        });
      }
    } catch (e) {
      print("Error fetching Stripe Link snippet: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: fetchStripeLinkSnippet,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            child: Text(
              'Pay with Stripe Link ${widget.currency} ${widget.totalAmount.toStringAsFixed(2)}',
            ),
          ),
          showWebView
              ? SizedBox(
                  height: 1500,
                  child: WebView(
                    initialUrl: url,
                    javascriptMode: JavascriptMode.unrestricted,
                    navigationDelegate: (NavigationRequest request) {
                      final returnUrl = dotenv.env['FAKE_RETURN_URL']!;
                      if (request.url.contains(returnUrl)) {
                        setState(() {
                          showWebView = false;
                          paymentSuccess = true;
                        });
                        return NavigationDecision.prevent;
                      }
                      return NavigationDecision.navigate;
                    },
                  ),
                )
              : Container(),
          if (paymentSuccess == true)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Successful payment",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
