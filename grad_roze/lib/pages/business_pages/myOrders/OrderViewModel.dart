import '/custom/util.dart';
import 'package:flutter/material.dart';
// To parse JSON responses
import 'OrderViewWidget.dart';

class OrderViewModel extends FlutterFlowModel<OrderViewWidget> {
  /// State fields for the order details
  late String orderId;
  late String customerUsername;
  late String businessSpecificTotal;
  List<dynamic> bouquets = [];

  /// Fetch bouquets in the order

  /// Initialize the model with the required data
  void initialize({
    required String orderId,
    required String customerUsername,
    required String businessSpecificTotal,
  }) {
    this.orderId = orderId;
    this.customerUsername = customerUsername;
    this.businessSpecificTotal = businessSpecificTotal;
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
