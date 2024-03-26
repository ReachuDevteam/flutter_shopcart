import 'package:demo2/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:demo2/graphql/mutations/checkout_mutations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';

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
  _StripePaymentCardWidgetState createState() =>
      _StripePaymentCardWidgetState();
}

class _StripePaymentCardWidgetState extends State<StripePaymentCardWidget> {
  bool? paymentSuccess;
  StreamSubscription? _sub;

  String url = "";
  bool showWebView = false;
  int orderId = -1;

  Uri? successUri;

  @override
  void initState() {
    super.initState();
    successUri = Uri.parse(dotenv.env['URL_TYPE']!);
    _initDeepLinkListener();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _initDeepLinkListener() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    }, onError: (err) {
      print("Error handling deep link: $err");
    });
  }

  void _handleDeepLink(Uri uri) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    String? cartIdFromUri = uri.queryParameters['cartId'];
    String? checkoutIdFromUri = uri.queryParameters['checkoutId'];
    String cartIdFromAppState = appState.cartId;
    String checkoutIdFromAppState = appState.checkoutState['id'];

    if (uri.scheme.toLowerCase() == successUri!.scheme.toLowerCase() &&
        cartIdFromUri == cartIdFromAppState &&
        checkoutIdFromUri == checkoutIdFromAppState) {
      setState(() {
        paymentSuccess = true;
      });
    }
  }

  Future<void> fetchStripeLinkSnippet() async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    final GraphQLClient client = GraphQLProvider.of(context).value;

    final email = widget.email;
    const paymentMethod = "Stripe";
    String cartId = appState.cartId;
    String checkoutId = appState.checkoutState['id'];

    String successUrl =
        "${dotenv.env['REDIRECT_APP_URL']!}?cartId=$cartId&checkoutId=$checkoutId";

    try {
      var result = await CheckoutMutations.checkoutInitPaymentStripe(
        client,
        email,
        paymentMethod,
        successUrl,
        checkoutId,
      );

      if (result != null && result["order_id"] != null) {
        setState(() {
          orderId = result["order_id"];
        });

        String url = result["checkout_url"];
        if (await canLaunch(url)) {
          await launch(
            url,
            forceSafariVC: false,
          );
        } else {
          throw 'Could not launch $url';
        }
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
              'Pay with Stripe ${widget.currency} ${widget.totalAmount.toStringAsFixed(2)}',
            ),
          ),
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
