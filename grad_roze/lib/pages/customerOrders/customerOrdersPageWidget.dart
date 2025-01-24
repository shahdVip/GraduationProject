import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grad_roze/pages/customerOrders/CustomerOrderCardWidget.dart';
import 'package:grad_roze/widgets/BusinessWidget/orderCardmodel.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';
import '/custom/theme.dart';
import '/custom/widgets.dart';

class CustomerOrdersWidget extends StatefulWidget {
  final String username;
  const CustomerOrdersWidget({super.key, required this.username});

  @override
  State<CustomerOrdersWidget> createState() => _MyOrdersWidgetState();
}

class _MyOrdersWidgetState extends State<CustomerOrdersWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedButton = 'Orders';
  List<OrderCardModel> _orders = [];
  bool _isLoading = false;
  Map<String, double> _orderPrices = {};

  Future<void> fetchOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse('$url/orders/customer/${widget.username}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          _orders = data.map<OrderCardModel>((order) {
            return OrderCardModel(
              orderId: order['_id'] ?? '',
              customerUsername: order['customerUsername'] ?? '',
              bouquetsId: List<String>.from(order['bouquetsId'] ?? []),
              businessUsername:
                  List<String>.from(order['businessUsername'] ?? []),
              totalPrice: order['totalPrice'] ?? 0,
              time: order['time'] ?? '',
              status: order['status'] is List
                  ? (order['status'] as List).join(', ')
                  : order['status'] ?? 'Unknown',
            );
          }).toList();
        });

        for (var order in _orders) {
          await fetchOrderPrice(order.orderId);
        }
      } else {
        print('Failed to fetch orders: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching orders: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchOrderPrice(String orderId) async {
    try {
      final response =
          await http.get(Uri.parse('$url/orders/getTotalPrice/$orderId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data != null && data['totalPrice'] != null) {
          setState(() {
            _orderPrices[orderId] = data['totalPrice'].toDouble();
          });
        }
      } else {
        print(
            'Failed to fetch price for order $orderId: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching price for order $orderId: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'My Orders',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Funnel Display',
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
          ),
          centerTitle: false,
          elevation: 0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FFButtonWidget(
                    onPressed: () {
                      setState(() {
                        selectedButton = 'Orders';
                      });
                      fetchOrders();
                    },
                    text: 'Orders',
                    options: FFButtonOptions(
                      width: 120,
                      height: 50,
                      color: selectedButton == 'Orders'
                          ? FlutterFlowTheme.of(context).alternate
                          : FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).labelSmall.override(
                                fontFamily: 'Funnel Display',
                                color: selectedButton == 'Orders'
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                      elevation: 2,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  FFButtonWidget(
                    onPressed: () {
                      setState(() {
                        selectedButton = 'Special Orders';
                      });
                    },
                    text: 'Special Orders',
                    options: FFButtonOptions(
                      width: 140,
                      height: 50,
                      color: selectedButton == 'Special Orders'
                          ? FlutterFlowTheme.of(context).alternate
                          : FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).labelSmall.override(
                                fontFamily: 'Funnel Display',
                                color: selectedButton == 'Special Orders'
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                      elevation: 2,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (selectedButton == 'Orders' && _orders.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    final price = _orderPrices[order.orderId] ?? 0;

                    return Column(
                      children: [
                        CustomerOrderCardWidget(
                          order: order,
                          username: widget.username,
                          orderId: order.orderId,
                          date: order.time,
                          price: price,
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
              )
            else if (selectedButton == 'Orders' && _orders.isEmpty)
              const Center(
                child: Text('click one of the buttons above!'),
              )
            else
              const SizedBox(),
          ],
        ),
      ),
    );
  }
}
