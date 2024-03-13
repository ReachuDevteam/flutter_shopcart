import 'package:demo2/models/cartItem.dart';
import 'package:flutter/foundation.dart';
import '../conts/data.dart';

class AppState with ChangeNotifier {
  String _selectedCurrency = CURRENCY_INIT;
  String _selectedCountry = COUNTRY_INIT;
  String _cartId = '';
  final List<CartItem> _cartItems = [];
  Map<String, dynamic> _checkoutState = {};

  AppScreen _selectedScreen = AppScreen.Products;

  String get selectedCurrency {
    debugPrint('Getting selected currency: $_selectedCurrency');
    return _selectedCurrency;
  }

  String get selectedCountry {
    debugPrint('Getting selected country: $_selectedCountry');
    return _selectedCountry;
  }

  String get cartId {
    debugPrint('Getting cart ID: $_cartId');
    return _cartId;
  }

  AppScreen get selectedScreen {
    debugPrint('Getting selected screen: $_selectedScreen');
    return _selectedScreen;
  }

  void setSelectedCurrency(String currency) {
    debugPrint('Setting selected currency: $currency');
    _selectedCurrency = currency;
    notifyListeners();
  }

  void setSelectedCountry(String country) {
    debugPrint('Setting selected country: $country');
    _selectedCountry = country;
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
