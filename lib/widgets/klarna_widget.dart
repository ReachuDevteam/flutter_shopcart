import 'package:demo2/state/app_state.dart';
import 'package:demo2/services/sdk.dart'; // <- SDK singleton
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
    final appState = Provider.of<AppState>(context, listen: false);
    final sdk = SdkService().sdk;

    final email = widget.email;
    final String checkoutId = appState.checkoutState['id'];

    try {
      // ✅ Migración: usamos SDK en lugar de CheckoutMutations + GraphQLClient
      final dto = await sdk.payment.klarnaInit(
        checkoutId: checkoutId,
        countryCode: appState.selectedCountry.toUpperCase(),
        href: dotenv.env['FAKE_RETURN_URL']!, // misma URL de retorno
        email: email,
      );

      if (dto != null && dto.orderId.isNotEmpty) {
        setState(() {
          orderId = dto.orderId;
          url =
              '${dotenv.env['REACHU_SERVER_URL']}/api/checkout/$checkoutId/payment-klarna-html-body';
          showWebView = true;
        });
      }
    } catch (e) {
      print("Error fetching Klarna HTML snippet: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Klarna error: $e')),
      );
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
              padding: const EdgeInsets.all(16),
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
