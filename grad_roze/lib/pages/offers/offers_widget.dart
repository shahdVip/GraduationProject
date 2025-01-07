import 'package:grad_roze/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import '/components/offer_card/offer_card_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'offers_model.dart';
export 'offers_model.dart';

class OffersWidget extends StatefulWidget {
  const OffersWidget({super.key});

  @override
  State<OffersWidget> createState() => _OffersWidgetState();
}

class _OffersWidgetState extends State<OffersWidget> {
  late OffersModel _model;
  List<dynamic> offers = [];
  bool isLoading = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OffersModel());

    fetchOffers();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<String?> getUsernameFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  // Future<void> fetchPendingOrders() async {
  //   const apiUrl =
  //       '$url/specialOrder/pending'; // Replace <port> with your actual port
  //   String? username = await getUsernameFromSharedPreferences();
  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'customerUsername': username
  //       }), // Replace 'john_doe' with your username
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       setState(() {
  //         orders = data;
  //         isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       print('Failed to fetch orders: ${response.body}');
  //     }
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print('Error: $e');
  //   }
  // }

  Future<void> fetchOffers() async {
    const apiUrl =
        '$url/offers/customer'; // Replace <url> with your API base URL
    String? username = await getUsernameFromSharedPreferences();

    if (username == null || username.isEmpty) {
      setState(() {
        isLoading = false;
      });
      print('Error: Username is missing in shared preferences.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'customerUsername': username}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          offers =
              data['offers']; // Access the 'offers' array from the response
          isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          offers = []; // No offers found for this customer
          isLoading = false;
        });
        print('No offers found: ${response.body}');
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to fetch offers: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void refreshOffers() {
    setState(() {
      // You can fetch the updated list of offers from your backend here
      // For now, just simulate the refresh by fetching new data
      fetchOffers(); // Replace this with your data fetching logic
    });
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
            'Offers',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  fontFamily: 'Funnel Display',
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
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : offers.isEmpty
                    ? Center(child: Text('No offers found.'))
                    : ListView.builder(
                        itemCount: offers.length,
                        itemBuilder: (context, index) {
                          final offer = offers[index];
                          return OfferCardWidget(
                            offer: offer,
                            onDelete: () {
                              // Pass the callback function to the OfferViewWidget
                              refreshOffers();
                            },
                          );
                        },
                      ),
          ),
        ),
      ),
    );
  }
}
