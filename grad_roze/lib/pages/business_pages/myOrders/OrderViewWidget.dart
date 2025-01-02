import 'package:grad_roze/pages/business_pages/myOrders/AcceptOrDenyWidget.dart';
import 'package:grad_roze/widgets/BusinessWidget/BouquetInOrderCardModel.dart';
import 'package:grad_roze/widgets/BusinessWidget/BouquetInOrderCardWidget.dart';
import 'package:grad_roze/widgets/BusinessWidget/orderCardmodel.dart';

import '/custom/theme.dart';
import '/custom/util.dart';
import 'package:flutter/material.dart';
import '/config.dart' show url;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'OrderViewModel.dart'; // To parse JSON responses

class OrderViewWidget extends StatefulWidget {
  final String orderId;
  final String customerUserName;
  final int businessSpecificTotal;
  final String business;
  final String status;
  final OrderCardModel order;

  const OrderViewWidget({
    super.key,
    required this.orderId,
    required this.customerUserName,
    required this.businessSpecificTotal,
    required this.business,
    required this.status,
    required this.order,
  });

  @override
  State<OrderViewWidget> createState() => _OrderViewWidgetState();
}

class _OrderViewWidgetState extends State<OrderViewWidget> {
  late OrderViewModel _model;
  List<BouquetInOrderCardModel> _bouquets = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrderViewModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
    _fetchBouquetsInOrder();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _fetchBouquetsInOrder() async {
    try {
      final response = await http.get(
        Uri.parse(
            '$url/orders/${widget.orderId}/business/${widget.business}/items'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          _bouquets = data.map((item) {
            return BouquetInOrderCardModel(
              bouquetId: item[
                  '_id'], // Replace with actual field from your API response
              bouquetName: item['name'],
              imageUrl: item['imageURL'] ?? '',
              price: item['price'].toDouble(),
              rating: (item['rating'] ?? 0).toDouble(),
            );
          }).toList();
        });
      } else {
        throw Exception('Failed to load bouquets');
      }
    } catch (e) {
      print('Error fetching bouquets: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondary,
          automaticallyImplyLeading: false,
          actions: const [],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            onPressed: () {
              Navigator.pop(context); // Navigate back
            },
          ),
          centerTitle: false,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 16.0), // Add top padding
          child: SafeArea(
            top: true,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Align(
                    alignment: const AlignmentDirectional(0, -1),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 970,
                      ),
                      decoration: const BoxDecoration(),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20, 0, 0, 0),
                              child: Text(
                                'Order Details',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .headlineLarge
                                    .override(
                                        fontFamily: 'Funnel Display',
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                        color: FlutterFlowTheme.of(context)
                                            .primary),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 20, 16, 0),
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: const AlignmentDirectional(-1, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Align(
                                        alignment:
                                            const AlignmentDirectional(-1, 0),
                                        child: Text(
                                          'OrderID:',
                                          style: FlutterFlowTheme.of(context)
                                              .labelSmall
                                              .override(
                                                fontFamily: 'Funnel Display',
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(1, 0),
                                      child: Text(
                                        widget.orderId,
                                        style: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .override(
                                                fontFamily: 'Funnel Display',
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ]
                                      .addToStart(const SizedBox(width: 40))
                                      .addToEnd(const SizedBox(width: 40)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 20, 16, 0),
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: const AlignmentDirectional(-1, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Align(
                                        alignment:
                                            const AlignmentDirectional(-1, 0),
                                        child: Text(
                                          'OrderedBy:',
                                          style: FlutterFlowTheme.of(context)
                                              .labelSmall
                                              .override(
                                                fontFamily: 'Funnel Display',
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(1, 0),
                                      child: Text(
                                        widget.customerUserName,
                                        style: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .override(
                                                fontFamily: 'Funnel Display',
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ]
                                      .addToStart(const SizedBox(width: 40))
                                      .addToEnd(const SizedBox(width: 40)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 10, 16, 0),
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: const AlignmentDirectional(-1, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Align(
                                        alignment:
                                            const AlignmentDirectional(-1, 0),
                                        child: Text(
                                          'Total Price:',
                                          style: FlutterFlowTheme.of(context)
                                              .labelSmall
                                              .override(
                                                fontFamily: 'Funnel Display',
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(1, 0),
                                      child: Text(
                                        '\$${widget.businessSpecificTotal.toString()}',
                                        style: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .override(
                                                fontFamily: 'Funnel Display',
                                                letterSpacing: 0.0,
                                                useGoogleFonts: false,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ]
                                      .addToStart(const SizedBox(width: 40))
                                      .addToEnd(const SizedBox(width: 40)),
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 20, 0, 0),
                                child: AcceptOrDenyWidget(
                                  order: widget.order,
                                  business: widget.business,
                                )),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 20, 0, 0),
                              child: ListView(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 44),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: _bouquets.map((bouquet) {
                                  return BouquetInOrderCardWidget(
                                    bouquet: bouquet,
                                    onArrowPressed: () {
                                      // Handle action when the arrow is pressed
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
