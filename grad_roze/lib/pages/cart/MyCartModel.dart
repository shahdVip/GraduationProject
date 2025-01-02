import 'dart:convert';

import 'package:grad_roze/config.dart';

import '../../components/cart_item/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyCartModel extends ChangeNotifier {
  List<CartItemModel> cartItems = [];
  bool isLoading = false;
  String? errorMessage;
  double totalPrice = 0.0;

  /// Fetch cart items by username
  Future<void> fetchCartItems(String username) async {
    print("Fetching cart items for $username...");

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final apiUrl = '$url/cart/$username';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print('API Response: ${response.body}');

        List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          cartItems = data.map((json) => CartItemModel.fromJson(json)).toList();
          totalPrice = cartItems.fold(0.0, (sum, item) => sum + item.price);
        } else {
          cartItems = [];
          totalPrice = 0.0;
          print('No items found in the cart for $username.');
        }

        print('Cart Items: $cartItems');
        print('Total Price: $totalPrice');
      } else {
        errorMessage =
            'Failed to fetch cart items. Status code: ${response.statusCode}, Response: ${response.body}';
        print(errorMessage);
      }
    } catch (error) {
      errorMessage = 'Error fetching cart items: $error';
      print(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Calculate the total price of items in the cart
}
