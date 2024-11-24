import 'package:grad_roze/config.dart';
import 'package:grad_roze/custom/animations.dart';
import 'package:grad_roze/widgets/Bouquet/BouquetViewWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/widgets/top_picks_component/top_picks_component_widget.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

import 'explore_model.dart';
export 'explore_model.dart';

class Item {
  final String name;
  final String business;
  final double price;
  final String imageURL;

  Item(
      {required this.name,
      required this.business,
      required this.price,
      required this.imageURL});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      business: json['business'],
      price: json['price'].toDouble(),
      imageURL: json['imageURL'],
    );
  }
}

class ExploreWidget extends StatefulWidget {
  const ExploreWidget({super.key});

  @override
  State<ExploreWidget> createState() => _ExploreWidgetState();
}

class _ExploreWidgetState extends State<ExploreWidget> {
  late ExploreModel _model;
  late Future<List<BouquetViewModel>> _itemsFuture;
  final animationsMap = <String, AnimationInfo>{};

  Future<List<BouquetViewModel>> fetchRecommendedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username'); // Get username

    if (username == null) {
      print("Username not found, user needs to sign in");
      return [];
    }

    final response = await http.post(
      Uri.parse('$url/item/recommendations'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username}),
    );
    print('Username: $username');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      // Parse the response body
      List<dynamic> data = jsonDecode(response.body);
      // Convert the JSON to a list of BouquetViewModel objects
      return data.map((item) => BouquetViewModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _itemsFuture = fetchRecommendedItems();

    _model = createModel(context, () => ExploreModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
      child: Container(
        width: double.infinity,
        height: 450,
        decoration: BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Text(
                        'Blossoms to Match Your Style',
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .titleMediumFamily,
                                  color: FlutterFlowTheme.of(context).secondary,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .titleMediumFamily),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 1000,
              decoration: BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                    child: Container(
                      width: double.infinity,
                      height: 420,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: FutureBuilder<List<BouquetViewModel>>(
                        future: fetchRecommendedItems(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data == null ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text('No items found'));
                          }

                          final bouquets = snapshot.data!;
                          return GridView.builder(
                            itemCount: bouquets.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              final bouquet = bouquets[index];
                              return BouquetViewWidget(model: bouquet);
                            },
                          );
                        },
                      ),
                    ).animateOnPageLoad(
                        animationsMap['containerOnPageLoadAnimation']!),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 24),
                child: FFButtonWidget(
                  onPressed: () {
                    print('Button pressed ...');
                  },
                  text: 'View More',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 45,
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: Color(0x00040425),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).titleSmallFamily,
                          color: FlutterFlowTheme.of(context).secondary,
                          fontSize: 14,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).titleSmallFamily),
                        ),
                    elevation: 0,
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).secondary,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
