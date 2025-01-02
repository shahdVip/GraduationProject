import 'package:grad_roze/pages/business_pages/myOrders/myOrdersWidget.dart';
import 'package:grad_roze/widgets/BusinessWidget/orderCardmodel.dart';

import '/custom/util.dart';
import 'package:flutter/material.dart';
import '/config.dart' show url;
import 'package:http/http.dart' as http;
// To parse JSON responses

class MyOrdersModel extends FlutterFlowModel<MyOrdersWidget> {
  ///  State fields for stateful widgets in this page.
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  // List to hold fetched orders
  List<OrderCardModel> orders = [];

  // Fetch orders by business
  Future<void> fetchAllOrders(String business) async {
    final response =
        await http.get(Uri.parse('$url/orders/business/$business'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      print('Fetched Orders: $jsonResponse'); // Debug the API response
      orders = jsonResponse.map((order) {
        return OrderCardModel(
          orderId: order['_id'],
          customerUsername: order['customerUsername'],
          bouquetsId: List<String>.from(order['bouquetsId']),
          businessUsername: List<String>.from(order['businessUsername']),
          totalPrice: order['totalPrice'],
          time: order['time'],
          status: order['status'],
        );
      }).toList();
      print('Parsed Orders: $orders'); // Debug the parsed orders
    } else {
      print('Failed to fetch orders: ${response.statusCode}');
    }
  }

// Fetch orders by business and status
  Future<void> fetchOrdersByBusinessAndStatus(
      String business, String status) async {
    try {
      final response = await http.get(
        Uri.parse('$url/orders/business/$business/$status'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        print('Fetched Orders by Status: $jsonResponse'); // Debug API response

        orders = jsonResponse.map((order) {
          return OrderCardModel(
            orderId: order['_id'],
            customerUsername: order['customerUsername'],
            bouquetsId: List<String>.from(order['bouquetsId']),
            businessUsername: List<String>.from(order['businessUsername']),
            totalPrice: order['totalPrice'],
            time: order['time'],
            status: order['status'], // Status should be a string here
          );
        }).toList();

        print('Parsed Orders by Status: $orders'); // Debug parsed orders
      } else if (response.statusCode == 404) {
        print(
            'No orders found for business "$business" with status "$status".');
      } else {
        print('Failed to fetch orders by status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching orders by business and status: $error');
    }
  }

  @override
  void initState(BuildContext context) {
    textController = TextEditingController();
    textFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
