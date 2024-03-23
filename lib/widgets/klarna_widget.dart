import 'package:demo2/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:demo2/graphql/mutations/checkout_mutations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class KlarnaPaymentCardWidget extends StatefulWidget {
  final String email;
  final double totalAmount;
  final String currency;

  const KlarnaPaymentCardWidget({
    Key? key,
    required this.email,
    required this.totalAmount,
    required this.currency,
  }) : super(key: key);

  @override
  _KlarnaPaymentCardWidgetState createState() =>
      _KlarnaPaymentCardWidgetState();
}

class _KlarnaPaymentCardWidgetState extends State<KlarnaPaymentCardWidget> {
  bool? paymentSuccess;
  String url = "";
  bool showWebView = false;
  String orderId = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchKlarnaHtmlSnippet() async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    final GraphQLClient client = GraphQLProvider.of(context).value;

    final email = widget.email;
    String checkoutId = appState.checkoutState['id'];

    try {
      var result = await CheckoutMutations.checkoutInitPaymentKlarna(
        client,
        checkoutId,
        appState.selectedCountry.toUpperCase(),
        dotenv.env['FAKE_RETURN_URL']!,
        email,
      );

      if (result != null && result["order_id"] != null) {
        setState(() {
          orderId = result["order_id"];
          url =
              '${dotenv.env['REACHU_SERVER_URL']}/api/checkout/${checkoutId}/payment-klarna-html-body';
        });

        setState(() {
          showWebView = true;
        });
      }
    } catch (e) {
      print("Error fetching Klarna HTML snippet: $e");
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
            onPressed: fetchKlarnaHtmlSnippet,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            child: Text(
              'Pay with Klarna ${widget.currency} ${widget.totalAmount.toStringAsFixed(2)}',
            ),
          ),
          showWebView
              ? SizedBox(
                  height: 1500,
                  child: WebView(
                    initialUrl: url,
                    javascriptMode: JavascriptMode.unrestricted,
                    navigationDelegate: (NavigationRequest request) {
                      final returnUrl =
                          '${dotenv.env['FAKE_RETURN_URL']}?order_id=$orderId&payment_processor=KLARNA';
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
                color: Colors.green,
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
