import 'package:grad_roze/pages/customerOrders/OrdersFromBusinessWidget.dart';
import 'package:grad_roze/widgets/BusinessWidget/orderCardmodel.dart';

import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import 'package:flutter/material.dart';

class BusinessInOrderCardWidget extends StatefulWidget {
  final String username;
  final String orderId;
  final String businessName;
  final String status;
  final int index;
  final OrderCardModel order;

  const BusinessInOrderCardWidget({
    super.key,
    required this.businessName,
    required this.status,
    required this.username,
    required this.orderId,
    required this.order,
    required this.index,
  });

  @override
  State<BusinessInOrderCardWidget> createState() =>
      _BusinessInOrderCardWidgetState();
}

class _BusinessInOrderCardWidgetState extends State<BusinessInOrderCardWidget> {
  Color _getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'denied':
        return Colors.red.withOpacity(0.1); // Light red
      case 'approved':
        return Colors.green.withOpacity(0.1); // Light green
      default:
        return Colors.grey.withOpacity(0.1); // Light grey
    }
  }

  IconData _getBusinessIcon(String businessName) {
    // Map businessName to an icon. Add more cases as needed.
    switch (businessName.toLowerCase()) {
      case 'flowermuse':
        return Icons.local_florist; // Example: Flower business
      case 'paliNature':
        return Icons.nature_people; // Example: Nature-related business
      case 'techGuru':
        return Icons.devices; // Example: Technology business
      default:
        return Icons.business; // Default business icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 0,
            color: FlutterFlowTheme.of(context).alternate,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  _getBusinessIcon(widget.businessName),
                  color: FlutterFlowTheme.of(context).primary,
                  size: 28,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'from:',
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                fontFamily: 'Funnel Display',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.businessName,
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: 'Funnel Display',
                                    fontWeight: FontWeight.bold,
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: _getStatusBackgroundColor(widget.status),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.status,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Funnel Display',
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlutterFlowIconButton(
                    borderRadius: 8,
                    buttonSize: 40,
                    fillColor: FlutterFlowTheme.of(context).primary,
                    icon: Icon(
                      Icons.arrow_forward_sharp,
                      color: FlutterFlowTheme.of(context).info,
                      size: 24,
                    ),
                    onPressed: () {
                      if (widget.index < 0 ||
                          widget.index >=
                              widget.order.businessUsername.length) {
                        print('Error: Index out of range');
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrdersFromBusinessWidget(
                                  business: widget
                                      .order.businessUsername[widget.index],
                                  orderId: widget.order.orderId,
                                  username: widget.username,
                                  order: widget.order,
                                  status: widget.status,
                                )),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
