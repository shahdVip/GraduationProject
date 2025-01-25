import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grad_roze/components/customerOrders/businessInOrderCardWidget.dart';
import 'package:grad_roze/widgets/BusinessWidget/orderCardmodel.dart';
import 'package:http/http.dart' as http;
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';

import '../../config.dart';

class CustomerOrderViewWidget extends StatefulWidget {
  final OrderCardModel order;

  final String orderId;
  final String username;

  const CustomerOrderViewWidget({
    super.key,
    required this.orderId,
    required this.username,
    required this.order,
  });

  @override
  State<CustomerOrderViewWidget> createState() =>
      _CustomerOrderViewWidgetState();
}

class _CustomerOrderViewWidgetState extends State<CustomerOrderViewWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic>? orderDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    try {
      final response =
          await http.get(Uri.parse('$url/orders/${widget.orderId}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          orderDetails = data;
          isLoading = false;
        });
      } else {
        print('Failed to fetch order details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching order details: $e');
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
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: FlutterFlowTheme.of(context).primary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Order Details',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Funnel Display',
                  color: FlutterFlowTheme.of(context).primary,
                  useGoogleFonts: false,
                ),
          ),
          elevation: 0,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : orderDetails == null
                ? const Center(child: Text('Order not found.'))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order ID
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 16, 16, 0),
                          child: _buildStyledRow(
                            context,
                            label: 'Order ID:',
                            value: orderDetails!['_id'] ?? 'N/A',
                          ),
                        ),
                        // Ordered By
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 10, 16, 0),
                          child: _buildStyledRow(
                            context,
                            label: 'Ordered By:',
                            value: orderDetails!['customerUsername'] ?? 'N/A',
                          ),
                        ),
                        // Total Price
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 10, 16, 0),
                          child: _buildStyledRow(
                            context,
                            label: 'Total Price:',
                            value: '\$${orderDetails!['totalPrice'] ?? 0.0}',
                          ),
                        ),
                        // List of Businesses
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              orderDetails!['businessUsername']?.length ?? 0,
                          itemBuilder: (context, index) {
                            final business =
                                orderDetails!['businessUsername'][index];
                            final status =
                                orderDetails!['status'][index] ?? 'Unknown';

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: BusinessInOrderCardWidget(
                                businessName: business,
                                status: status,
                                username: widget.username,
                                orderId: widget.orderId,
                                order: widget.order,
                                index: index,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildStyledRow(BuildContext context,
      {required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 8), // Spacing between rows
      decoration: BoxDecoration(
        color:
            FlutterFlowTheme.of(context).primaryBackground, // Background color
        borderRadius: BorderRadius.circular(12), // Rounded corners
        border: Border.all(
          color: FlutterFlowTheme.of(context).primary, // Border color
          width: 2, // Border width
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Text(
                label,
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Funnel Display',
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(1, 0),
            child: Text(
              value,
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: 'Funnel Display',
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
