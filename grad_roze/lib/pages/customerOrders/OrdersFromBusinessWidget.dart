import 'package:grad_roze/pages/business_pages/myOrders/AcceptButtonWidget.dart';
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

class OrdersFromBusinessWidget extends StatefulWidget {
  final String username;
  final String business;
  final String orderId;
  final String status;
  final OrderCardModel order;

  const OrdersFromBusinessWidget({
    super.key,
    required this.business,
    required this.orderId,
    required this.username,
    required this.order,
    required this.status,
  });

  @override
  State<OrdersFromBusinessWidget> createState() =>
      _OrdersFromBusinessWidgetState();
}

class _OrdersFromBusinessWidgetState extends State<OrdersFromBusinessWidget> {
  List<BouquetInOrderCardModel> _bouquets = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBouquetsFromBusiness();
  }

  Future<void> _fetchBouquetsFromBusiness() async {
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
              bouquetId: item['_id'], // Replace with actual field from API
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
    } finally {
      setState(() {
        _isLoading = false;
      });
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
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 20),
                  child: Text(
                    'Bouquets from : ${widget.business}',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).headlineLarge.override(
                          fontFamily: 'Funnel Display',
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                  ),
                ),
                // AcceptOrDenyWidget placed right after the "Bouquets" text
                Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                    child: AcceptButtonWidget(
                      order: widget.order,
                      business: widget.business,
                    )),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 44),
                          itemCount: _bouquets.length,
                          itemBuilder: (context, index) {
                            final bouquet = _bouquets[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: BouquetInOrderCardWidget(
                                bouquet: bouquet,
                                onArrowPressed: () {
                                  // Handle action when the arrow is pressed
                                },
                              ),
                            );
                          },
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
