import 'package:grad_roze/widgets/BusinessWidget/OrderCardWidget.dart';

import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'myOrdersModel.dart';
export 'myOrdersModel.dart';

class MyOrdersWidget extends StatefulWidget {
  final String business;
  const MyOrdersWidget({super.key, required this.business});

  @override
  State<MyOrdersWidget> createState() => _MyOrdersWidgetState();
}

class _MyOrdersWidgetState extends State<MyOrdersWidget> {
  late MyOrdersModel _model;
  String status = "";
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyOrdersModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      status = ""; // Set status to "" initially for all orders
      await _model.fetchAllOrders(widget.business); // Fetch all orders
      safeSetState(() {}); // Refresh the UI
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
          title: Text(
            'My Orders',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Funnel Display',
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                  color: FlutterFlowTheme.of(context).primary,
                ),
          ),
          centerTitle: false,
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          children: [
            Container(
              width: double.infinity,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0x00FFFFFF),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          setState(() {
                            status = ""; // Reset for "All" button
                          });
                          print(
                              'Fetching all orders for business: ${widget.business}');
                          await _model.fetchAllOrders(
                              widget.business); // Fetch all orders
                          safeSetState(() {}); // Refresh the UI
                        },
                        text: 'All',
                        options: FFButtonOptions(
                          width: 80,
                          height: 40,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 0, 16, 0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: FlutterFlowTheme.of(context)
                              .labelSmall
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelSmallFamily,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                letterSpacing: 0.0,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .labelSmallFamily),
                              ),
                          elevation: 0,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          setState(() {
                            status =
                                "pending"; // Set status for "Pending" button
                          });
                          print(
                              'Fetching orders with status: $status for business: ${widget.business}');
                          await _model.fetchOrdersByBusinessAndStatus(
                              widget.business, status);
                          safeSetState(() {}); // Refresh the UI
                        },
                        text: 'Pending',
                        options: FFButtonOptions(
                          width: 80,
                          height: 40,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 0, 16, 0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: FlutterFlowTheme.of(context)
                              .labelSmall
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelSmallFamily,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                letterSpacing: 0.0,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .labelSmallFamily),
                              ),
                          elevation: 0,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          setState(() {
                            status =
                                "accepted"; // Example for the "Pending" button
                          });
                          await _model.fetchOrdersByBusinessAndStatus(
                              widget.business, status);
                          safeSetState(() {}); // Refresh the UI
                        },
                        text: 'Accepted',
                        options: FFButtonOptions(
                          width: 80,
                          height: 40,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 10, 0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: FlutterFlowTheme.of(context)
                              .labelSmall
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelSmallFamily,
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                letterSpacing: 0.0,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .labelSmallFamily),
                              ),
                          elevation: 0,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          setState(() {
                            status =
                                "waiting"; // Example for the "Pending" button
                          });
                          await _model.fetchOrdersByBusinessAndStatus(
                              widget.business, status);
                          safeSetState(() {}); // Refresh the UI
                        },
                        text: 'Waiting',
                        options: FFButtonOptions(
                          width: 80,
                          height: 40,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 0, 16, 0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: FlutterFlowTheme.of(context)
                              .labelSmall
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelSmallFamily,
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                letterSpacing: 0.0,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .labelSmallFamily),
                              ),
                          elevation: 0,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          setState(() {
                            status = "done"; // Example for the "Pending" button
                          });
                          await _model.fetchOrdersByBusinessAndStatus(
                              widget.business, status);
                          safeSetState(() {}); // Refresh the UI
                        },
                        text: 'Done',
                        options: FFButtonOptions(
                          width: 80,
                          height: 40,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 0, 16, 0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: FlutterFlowTheme.of(context)
                              .labelSmall
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelSmallFamily,
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                letterSpacing: 0.0,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .labelSmallFamily),
                              ),
                          elevation: 0,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    FFButtonWidget(
                      onPressed: () async {
                        setState(() {
                          status = "denied"; // Example for the "Pending" button
                        });
                        await _model.fetchOrdersByBusinessAndStatus(
                            widget.business, status);
                        safeSetState(() {}); // Refresh the UI
                      },
                      text: 'Denied',
                      options: FFButtonOptions(
                        width: 80,
                        height: 40,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        iconPadding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).secondary,
                        textStyle: FlutterFlowTheme.of(context)
                            .labelSmall
                            .override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).labelSmallFamily,
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              letterSpacing: 0.0,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .labelSmallFamily),
                            ),
                        elevation: 0,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_model.orders.isEmpty)
              Center(
                child: Text(
                  'No orders found.',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _model.orders.length,
              itemBuilder: (context, index) {
                final order = _model.orders[index];

                // Filter orders based on the status
                if (status.isNotEmpty && order.status != status) {
                  return const SizedBox
                      .shrink(); // Skip orders that don't match the status
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: OrderCardWidget(
                    order: order,
                    business: widget.business,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
