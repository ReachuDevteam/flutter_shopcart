import 'package:demo2/models/cartItem.dart';
import 'package:demo2/models/market.dart';
import 'package:flutter/foundation.dart';
import '../conts/data.dart';

class AppState with ChangeNotifier {
  String _selectedCurrency = CURRENCY_INIT;
  String _selectedCurrencySymbol = '';
  String _selectedCountry = COUNTRY_INIT;
  String _cartId = '';
  final List<CartItem> _cartItems = [];
  Map<String, dynamic> _checkoutState = {};
  List<Market> _availableMarkets = [];
  final Map<String, String> _selectedShippingForItems = {};

  AppScreen _selectedScreen = AppScreen.Products;

  String get selectedCurrency => _selectedCurrency;
  String get selectedCurrencySymbol => _selectedCurrencySymbol;
  String get selectedCountry => _selectedCountry;
  List<Market> get availableMarkets => _availableMarkets;
  Map<String, String> get selectedShippingForItems => _selectedShippingForItems;

  // Obtener el shipping_id para un item_id
  String? getShippingForItem(String itemId) {
    return _selectedShippingForItems[itemId];
  }

  void updateShippingForItem(String itemId, String shippingId) {
    _selectedShippingForItems[itemId] = shippingId;
    notifyListeners();
  }

  void updateShippingForSupplier(List<String> itemIds, String shippingId) {
    for (var itemId in itemIds) {
      _selectedShippingForItems[itemId] = shippingId;
    }
    notifyListeners();
  }

  void clearShippingSelections() {
    _selectedShippingForItems.clear();
    notifyListeners();
  }

  String get cartId {
    debugPrint('Getting cart ID: $_cartId');
    return _cartId;
  }

  AppScreen get selectedScreen {
    debugPrint('Getting selected screen: $_selectedScreen');
    return _selectedScreen;
  }

  void initializeMarkets(List<Market> markets) {
    _availableMarkets = markets;

    final initialMarket = markets.isNotEmpty
        ? markets.firstWhere(
            (market) => market.code == _selectedCountry,
            orElse: () => markets.first,
          )
        : null;
    if (initialMarket != null) {
      _selectedCountry = initialMarket.code;
      _selectedCurrency = initialMarket.currency.code;
      _selectedCurrencySymbol = initialMarket.currency.symbol;
    } else {
      _selectedCountry = '';
      _selectedCurrency = '';
      _selectedCurrencySymbol = '';
    }

    notifyListeners();
  }

  void setSelectedCountry(String country) {
    _selectedCountry = country;

    final selectedMarket =
        _availableMarkets.firstWhere((market) => market.code == country);
    _selectedCurrency = selectedMarket.currency.code;
    _selectedCurrencySymbol = selectedMarket.currency.symbol;

    notifyListeners();
  }

  void setCartId(String cartId) {
    debugPrint('Setting cart ID: $cartId');
    _cartId = cartId;
    notifyListeners();
  }

  void setSelectedScreen(AppScreen screen) {
    debugPrint('Setting selected screen: $screen');
    _selectedScreen = screen;
    notifyListeners();
  }

  List<CartItem> get cartItems {
    debugPrint('Getting cart items: $_cartItems');
    return _cartItems;
  }

  void addCartItem(CartItem cartItem) {
    debugPrint('Adding cart item: $cartItem');
    _cartItems.add(cartItem);
    notifyListeners();
  }

  void removeCartItem(String cartItemId) {
    debugPrint('Removing cart item with product ID: $cartItemId');
    _cartItems.removeWhere((item) => item.cartItemId == cartItemId);
    notifyListeners();
  }

  void updateCartItemQuantity(String cartItemId, int quantity) {
    debugPrint(
        'Updating cart item with product ID: $cartItemId to quantity: $quantity');
    int index = _cartItems.indexWhere((item) => item.cartItemId == cartItemId);
    if (index != -1) {
      _cartItems[index].quantity = quantity;
      notifyListeners();
    }
  }

  Map<String, dynamic> get checkoutState {
    debugPrint('Getting checkout: $_checkoutState');
    return _checkoutState;
  }

  void setCheckoutState(Map<String, dynamic> newState) {
    debugPrint('Setting checkout: $newState');
    _checkoutState = newState;
    notifyListeners();
  }
}
