import 'package:demo2/screens/checkout_screen.dart';
import 'package:demo2/screens/payment_screen.dart';
import 'package:demo2/screens/products_screen.dart';
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

  String? cartId = await CartMutations.executeCreateCartMutation(
    client.value, // The GraphQL client
    customerSessionId: generatedUuid,
    currency: CURRENCY_INIT,
  ).then((result) => result?['cart_id']);

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        AppState appState = AppState();
        if (cartId != null) {
          appState.setCartId(cartId);
        }
        return appState;
      },
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
  final Map<String, String> _countriesWithFlags = {
    'us': 'assets/images/flags/us.png',
    'no': 'assets/images/flags/no.png',
    'gb': 'assets/images/flags/gb.png',
    'ca': 'assets/images/flags/ca.png',
    'fr': 'assets/images/flags/fr.png',
    'de': 'assets/images/flags/de.png',
    'jp': 'assets/images/flags/jp.png',
    'cn': 'assets/images/flags/cn.png',
    'br': 'assets/images/flags/br.png',
    'it': 'assets/images/flags/it.png',
  };

  static const Map<String, IconData> _currencyIcons = {
    'USD': Icons.attach_money,
    'EUR': Icons.euro_symbol,
    'NOK': Icons.money,
  };

  void _onItemTapped(int index) {
    final appState = Provider.of<AppState>(context, listen: false);

    if ((index == 1 || index == 2) && appState.cartItems.isEmpty) {
      // Display a message indicating that the cart is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Your shopping cart is empty. Add products before proceeding.")),
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
              items: _countriesWithFlags.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Row(
                    children: [
                      Image.asset(entry.value, width: 30, height: 20),
                      const SizedBox(width: 10),
                      Text(entry.key.toUpperCase()),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: appState.selectedCurrency,
              onChanged: (newValue) {
                if (newValue != null) {
                  appState.setSelectedCurrency(newValue);
                }
              },
              items: _currencyIcons.keys.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: <Widget>[
                      Icon(_currencyIcons[value], size: 20),
                      const SizedBox(width: 5),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const CartIconWidget(),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Checkout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payment',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  final List<Widget> _widgetOptions = <Widget>[
    const ProductsScreen(),
    const CheckoutScreen(),
    const PaymentScreen(),
  ];
}
