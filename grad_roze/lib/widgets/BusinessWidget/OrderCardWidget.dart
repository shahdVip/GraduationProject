import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grad_roze/config.dart';
import 'package:grad_roze/custom/nav/nav.dart';
import 'package:grad_roze/pages/business_pages/myOrders/OrderViewWidget.dart';
import '/custom/theme.dart';
import '/custom/widgets.dart';
import 'package:grad_roze/widgets/BusinessWidget/orderCardmodel.dart';
import '/config.dart' show url;
import 'package:http/http.dart' as http;

class OrderCardWidget extends StatelessWidget {
  final OrderCardModel order;
  final String business; // Pass the business name

  const OrderCardWidget({Key? key, required this.order, required this.business})
      : super(key: key);

  Future<int?> fetchBusinessSpecificTotal(
      String orderId, String business) async {
    try {
      final response = await http
          .get(Uri.parse('$url/orders/$orderId/business/$business/totalPrice'));
      if (response.statusCode == 200) {
        return int.parse(response.body); // Parse the plain total price
      } else {
        print('Failed to fetch total for business: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching business-specific total: $e');
      return null;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "pending":
        return const Color.fromARGB(82, 158, 158, 158); // Gray for pending
      case "denied":
        return const Color.fromARGB(64, 216, 56, 44); // Red for denied
      default:
        return const Color.fromARGB(
            73, 76, 175, 79); // Green for other statuses
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 570,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate,
            width: 2,
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Left Section
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: ${order.orderId}',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Funnel Display',
                            color: FlutterFlowTheme.of(context).primary,
                            fontWeight: FontWeight.w500,
                            useGoogleFonts: false,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        order.time,
                        style:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Funnel Display',
                                  useGoogleFonts: false,
                                ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                              order.status), // Dynamically set color
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2,
                          ),
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(7, 0, 7, 0),
                            child: Text(
                              order.status,
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Funnel Display',
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Right Section
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FutureBuilder<int?>(
                      future:
                          fetchBusinessSpecificTotal(order.orderId, business),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Loading indicator
                        } else if (snapshot.hasError || snapshot.data == null) {
                          return Text(
                            'Error',
                            style: TextStyle(color: Colors.red),
                          );
                        } else {
                          return Text(
                            '\$${snapshot.data}',
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  fontFamily: 'Funnel Display',
                                  color: FlutterFlowTheme.of(context).primary,
                                  useGoogleFonts: false,
                                ),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final int? total = await fetchBusinessSpecificTotal(
                            order.orderId, business);
                        if (total != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderViewWidget(
                                orderId: order.orderId,
                                customerUserName: order.customerUsername,
                                businessSpecificTotal: total.toInt(),
                                business: business,
                                status: order.status,
                                order: order, // Pass as integer
                              ),
                            ),
                          );
                        } else {
                          // Handle the case where total is null
                          print('Failed to fetch business-specific total');
                        }
                      },
                      child: Text(
                        'View details',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Funnel Display',
                              color: FlutterFlowTheme.of(context).primary,
                              decoration: TextDecoration
                                  .underline, // Underline for clickable effect
                              useGoogleFonts: false,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
