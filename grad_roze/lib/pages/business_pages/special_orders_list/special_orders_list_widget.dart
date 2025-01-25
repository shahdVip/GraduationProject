import 'package:grad_roze/components/business_components/my_order_card/my_order_card_widget.dart';
import 'package:grad_roze/components/business_components/pending_offer_card/pending_offer_card_widget.dart';

import '/custom/choice_chips.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import '/custom/form_field_controller.dart';
import '/components/business_components/special_order_card/special_order_card_widget.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'special_orders_list_model.dart';
export 'special_orders_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:grad_roze/config.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class SpecialOrdersListWidget extends StatefulWidget {
  const SpecialOrdersListWidget({super.key});

  @override
  State<SpecialOrdersListWidget> createState() =>
      _SpecialOrdersListWidgetState();
}

class _SpecialOrdersListWidgetState extends State<SpecialOrdersListWidget> {
  late SpecialOrdersListModel _model;
  late Future<List<dynamic>> specialOrders;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Fetch the username from shared preferences
  Future<String?> getUsernameFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<List<dynamic>> fetchSpecialOrdersWithBody(
      String? choice, Map<String?, String?> body) async {
    if (choice == 'Pending Offers') {
      final endpoint = '$url/offers/by-business';
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['data'];
        return data;
      } else if (response.statusCode == 404) {
        safeSetState(() {
          var message = 'No special orders found';
        });
        return [];
      } else {
        throw Exception('Failed to load pending offers');
      }
    } else {
      throw Exception('Invalid choice for POST request');
    }
  }

  Future<List<dynamic>> fetchSpecialOrders(String? choice) async {
    String endpoint;

    if (choice == 'New Orders') {
      String? username = await getUsernameFromSharedPreferences();
      endpoint =
          '$url/specialOrder/filter?status=New&businessUsernameOpp=$username';
    } else if (choice == 'My Orders') {
      String? username = await getUsernameFromSharedPreferences();
      endpoint =
          '$url/specialOrder/filter?businessUsername=$username&status=Assigned';
    } else {
      endpoint = '$url/specialOrder';
    }

    final response = await http.get(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load special orders');
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SpecialOrdersListModel());
    // Set the default choice to "New Orders"
    // Set the default choice to "New Orders"
    String defaultChoice = 'New Orders';
    _model.choiceChipsValue = defaultChoice; // Default selected chip value
    _model.choiceChipsValueController = FormFieldController<List<String>>(
      [defaultChoice], // Set the default value for the controller
    );
    specialOrders =
        fetchSpecialOrders("New Orders"); // Default to "New Orders" on init

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            'Special Orders',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  fontFamily: 'Funnel Display',
                  color: FlutterFlowTheme.of(context).secondary,
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: FlutterFlowChoiceChips(
                          options: [
                            ChipData('New Orders'),
                            ChipData('Pending Offers'),
                            ChipData('My Orders')
                          ],
                          onChanged: (val) async {
                            if (val != null) {
                              safeSetState(() {
                                _model.choiceChipsValue = val.firstOrNull;
                              });
                              // Fetch the corresponding orders and update the list
                              if (val.firstOrNull == 'Pending Offers') {
                                String? username =
                                    await getUsernameFromSharedPreferences();
                                specialOrders = fetchSpecialOrdersWithBody(
                                    val.firstOrNull,
                                    {'businessUsername': username});
                              } else {
                                specialOrders =
                                    fetchSpecialOrders(val.firstOrNull);
                              }
                            }
                          },
                          selectedChipStyle: ChipStyle(
                            backgroundColor:
                                FlutterFlowTheme.of(context).secondary,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Funnel Display',
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                            iconColor: FlutterFlowTheme.of(context).info,
                            iconSize: 16,
                            elevation: 0,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          unselectedChipStyle: ChipStyle(
                            backgroundColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Funnel Display',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                            iconColor:
                                FlutterFlowTheme.of(context).secondaryText,
                            iconSize: 16,
                            elevation: 0,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          chipSpacing: 8,
                          rowSpacing: 8,
                          multiselect: false,
                          alignment: WrapAlignment.start,
                          controller: _model.choiceChipsValueController ??=
                              FormFieldController<List<String>>(
                            [],
                          ),
                          wrapped: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                  child: FutureBuilder<List<dynamic>>(
                    future:
                        specialOrders, // Dynamic data based on the selected chip
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text('No orders available for this filter'));
                      } else {
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var order = snapshot.data![index];

                            // Render different widgets based on the selected chip
                            if (_model.choiceChipsValue == 'New Orders') {
                              return SpecialOrderCardWidget(order: order);
                            } else if (_model.choiceChipsValue == 'My Orders') {
                              return MyOrderCardWidget(order: order);
                            } else if (_model.choiceChipsValue ==
                                'Pending Offers') {
                              return PendingOfferCardWidget(order: order);
                            }
                            return null;
                          },
                        );
                      }
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
