import 'package:demo2/graphql/queries/market_queries.dart';
import 'package:demo2/models/market.dart';
import 'package:demo2/screens/checkout_screen.dart';
import 'package:demo2/screens/payment_screen.dart';
import 'package:demo2/screens/products_screen.dart';
import 'package:demo2/screens/shippingList_screen.dart';
import 'package:demo2/widgets/cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import './graphql/graphql_client.dart';
import './state/app_state.dart';
import 'conts/data.dart';
import './graphql/mutations/cart_mutations.dart';

void main() async {
  var uuid = const Uuid();
  String generatedUuid = uuid.v4();

  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  final ValueNotifier<GraphQLClient> client =
      GraphQLConfiguration.clientToQuery();

  final appState = AppState();

  final List<Market> markets =
      await MarketQueries.executeGetAvailableMarketsQuery(client.value);
  appState.initializeMarkets(markets);

  String? cartId = await CartMutations.executeCreateCartMutation(
          client.value, // The GraphQL client
          customerSessionId: generatedUuid,
          currency: appState.selectedCurrency,
          shippingCountry: appState.selectedCountry)
      .then((result) => result?['cart_id']);
  if (cartId != null) {
    appState.setCartId(cartId);
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => appState,
      child: MyApp(client: client),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Online Store',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _onItemTapped(int index) {
    final appState = Provider.of<AppState>(context, listen: false);

    if ((index == 1 || index == 2 || index == 3) &&
        appState.cartItems.isEmpty) {
      // Display a message indicating that the cart is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Your shopping cart is empty. Add products before proceeding.")),
      );
      return;
    }

    if ((index == 2 || index == 3) &&
        appState.selectedShippingForItems.isEmpty) {
      // Display a message indicating that the cart is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Your shopping cart is empty shipping. Add shipping before proceeding.")),
      );
      return;
    }

    setState(() {
      appState.setSelectedScreen(AppScreen.values[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final _selectedIndex = appState.selectedScreen.index;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Store'),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: appState.selectedCountry,
              onChanged: (value) {
                if (value != null) {
                  appState.setSelectedCountry(value);
                }
              },
              items: appState.availableMarkets.map((market) {
                return DropdownMenuItem<String>(
                  value: market.code,
                  child: Row(
                    children: [
                      Image.network(market.flag, width: 30, height: 20),
                      const SizedBox(width: 10),
                      Text(market.code.toUpperCase()),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                'Currency: ${appState.selectedCurrencySymbol}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const CartIconWidget(),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Shipping',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Checkout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payment',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  final List<Widget> _widgetOptions = <Widget>[
    const ProductsScreen(),
    const ShippingListScreen(),
    const CheckoutScreen(),
    const PaymentScreen()
  ];
}
