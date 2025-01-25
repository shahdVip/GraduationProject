import 'package:grad_roze/widgets/BusinessWidget/orderCardmodel.dart';

import '/custom/theme.dart';
import '/custom/widgets.dart';
import 'package:flutter/material.dart';

import 'CustomerOrderViewWidget.dart';

class CustomerOrderCardWidget extends StatelessWidget {
  final String username;
  final String orderId;
  final String date;
  final double price;
  final OrderCardModel order;

  const CustomerOrderCardWidget(
      {super.key,
      required this.orderId,
      required this.date,
      required this.price,
      required this.username,
      required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
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
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderId.isNotEmpty
                          ? orderId
                          : 'N/A', // Safeguard for orderId
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Funnel Display',
                            color: FlutterFlowTheme.of(context).primary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            useGoogleFonts: false,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        date.isNotEmpty
                            ? date
                            : 'Unknown Date', // Safeguard for date
                        style:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Funnel Display',
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${price.toStringAsFixed(2)}', // Safeguard for price
                    textAlign: TextAlign.end,
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: 'Funnel Display',
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                  ),
                  FFButtonWidget(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerOrderViewWidget(
                                  orderId: orderId,
                                  username: username,
                                  order: order,
                                )),
                      );
                    },
                    text: 'View details',
                    options: FFButtonOptions(
                      height: 20,
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      iconPadding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: const Color(0x00E3E7ED),
                      textStyle:
                          FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Funnel Display',
                                color: FlutterFlowTheme.of(context).primary,
                                letterSpacing: 0.0,
                                decoration: TextDecoration.underline,
                                useGoogleFonts: false,
                              ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
