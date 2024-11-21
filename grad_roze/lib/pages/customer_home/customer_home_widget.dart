import 'package:grad_roze/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/custom/animations.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'customer_home_model.dart';
export 'customer_home_model.dart';

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

class CustomerHomeWidget extends StatefulWidget {
  const CustomerHomeWidget({super.key});

  @override
  State<CustomerHomeWidget> createState() => _CustomerHomeWidgetState();
}

class _CustomerHomeWidgetState extends State<CustomerHomeWidget>
    with TickerProviderStateMixin {
  late CustomerHomeModel _model;
  late Future<List<Item>> _itemsFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};
  //final String baseUrl = 'http://192.168.1.9:3000';
  Future<List<Item>> fetchRecommendedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? username =
        prefs.getString('username'); // Get username from shared preferences

    if (username == null) {
      print("Username not found, user needs to sign in");
      return [];
    }
    // Update with your API URL
    final response = await http.post(
      Uri.parse('$url/item/recommendations'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username}),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Item.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  @override
  void initState() {
    super.initState();
    _itemsFuture = fetchRecommendedItems();
    _model = createModel(context, () => CustomerHomeModel());

    animationsMap.addAll({
      'rowOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 60.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 50.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

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
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Discover Your Next Favorite',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily: 'Funnel Display',
                              color: FlutterFlowTheme.of(context).primary,
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                      ),
                    ],
                  ).animateOnPageLoad(animationsMap['rowOnPageLoadAnimation']!),
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
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: FutureBuilder<List<Item>>(
                            future: _itemsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(
                                    child: Text(
                                  'No items found',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Funnel Display',
                                        useGoogleFonts: false,
                                        letterSpacing: 0.0,
                                      ),
                                ));
                              }

                              final items = snapshot.data!;
                              return GridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 1,
                                ),
                                itemCount: items.length > 4 ? 4 : items.length,
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12, 12, 0, 0),
                                    child: Container(
                                      width: 160,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 4,
                                            color: Color(0x3F15212B),
                                            offset: Offset(0.0, 3),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(12),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 12),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(8, 8, 8, 0),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: Image.network(
                                                      '$url${item.imageURL}',
                                                      width: double.infinity,
                                                      height: 110,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(16, 4, 16, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    item.name,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Funnel Display',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: false,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(16, 4, 16, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    item.business,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily:
                                                              'Funnel Display',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: false,
                                                        ),
                                                  ),
                                                  Text(
                                                    '\$${item.price.toStringAsFixed(2)}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              'Funnel Display',
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts: false,
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
                                },
                              );
                            },
                          ),
                          // child: GridView(
                          //   padding: EdgeInsets.zero,
                          //   gridDelegate:
                          //       SliverGridDelegateWithFixedCrossAxisCount(
                          //     crossAxisCount: 2,
                          //     crossAxisSpacing: 10,
                          //     childAspectRatio: 1,
                          //   ),
                          //   scrollDirection: Axis.vertical,
                          //   children: [
                          //     Padding(
                          //       padding: EdgeInsetsDirectional.fromSTEB(
                          //           12, 12, 0, 0),
                          //       child: Container(
                          //         width: 160,
                          //         height: 180,
                          //         decoration: BoxDecoration(
                          //           color: FlutterFlowTheme.of(context)
                          //               .secondaryBackground,
                          //           boxShadow: [
                          //             BoxShadow(
                          //               blurRadius: 4,
                          //               color: Color(0x3F15212B),
                          //               offset: Offset(
                          //                 0.0,
                          //                 3,
                          //               ),
                          //             )
                          //           ],
                          //           borderRadius: BorderRadius.circular(12),
                          //           shape: BoxShape.rectangle,
                          //         ),
                          //         child: Padding(
                          //           padding: EdgeInsetsDirectional.fromSTEB(
                          //               0, 0, 0, 12),
                          //           child: Column(
                          //             mainAxisSize: MainAxisSize.max,
                          //             children: [
                          //               Expanded(
                          //                 child: Padding(
                          //                   padding:
                          //                       EdgeInsetsDirectional.fromSTEB(
                          //                           8, 8, 8, 0),
                          //                   child: Container(
                          //                     width: double.infinity,
                          //                     height: 100,
                          //                     decoration: BoxDecoration(
                          //                       color:
                          //                           FlutterFlowTheme.of(context)
                          //                               .info,
                          //                       borderRadius:
                          //                           BorderRadius.circular(8),
                          //                     ),
                          //                     child: Padding(
                          //                       padding: EdgeInsetsDirectional
                          //                           .fromSTEB(0, 0, 0, 8),
                          //                       child: ClipRRect(
                          //                         borderRadius:
                          //                             BorderRadius.circular(12),
                          //                         child: Image.asset(
                          //                           'assets/images/shphoto.jpg',
                          //                           width: double.infinity,
                          //                           height: 110,
                          //                           fit: BoxFit.cover,
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),
                          //               Padding(
                          //                 padding:
                          //                     EdgeInsetsDirectional.fromSTEB(
                          //                         16, 4, 16, 0),
                          //                 child: Row(
                          //                   mainAxisSize: MainAxisSize.max,
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.spaceBetween,
                          //                   children: [
                          //                     Text(
                          //                       'item name',
                          //                       style:
                          //                           FlutterFlowTheme.of(context)
                          //                               .bodyMedium
                          //                               .override(
                          //                                 fontFamily:
                          //                                     'Funnel Display',
                          //                                 color: FlutterFlowTheme
                          //                                         .of(context)
                          //                                     .primary,
                          //                                 letterSpacing: 0.0,
                          //                                 useGoogleFonts: false,
                          //                               ),
                          //                     ),
                          //                     Text(
                          //                       '\$120',
                          //                       style:
                          //                           FlutterFlowTheme.of(context)
                          //                               .labelMedium
                          //                               .override(
                          //                                 fontFamily:
                          //                                     'Funnel Display',
                          //                                 letterSpacing: 0.0,
                          //                                 useGoogleFonts: false,
                          //                               ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //               Padding(
                          //                 padding:
                          //                     EdgeInsetsDirectional.fromSTEB(
                          //                         16, 4, 16, 0),
                          //                 child: Row(
                          //                   mainAxisSize: MainAxisSize.max,
                          //                   children: [
                          //                     Text(
                          //                       'business name',
                          //                       style:
                          //                           FlutterFlowTheme.of(context)
                          //                               .bodySmall
                          //                               .override(
                          //                                 fontFamily:
                          //                                     'Funnel Display',
                          //                                 color: FlutterFlowTheme
                          //                                         .of(context)
                          //                                     .secondaryText,
                          //                                 letterSpacing: 0.0,
                          //                                 useGoogleFonts: false,
                          //                               ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ).animateOnPageLoad(
                            animationsMap['containerOnPageLoadAnimation']!),
                      ),
                      Flexible(
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(16, 12, 16, 24),
                          child: FFButtonWidget(
                            onPressed: () {
                              print('Button pressed ...');
                            },
                            text: 'Shop now',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 45,
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              iconPadding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: Color(0x00FFFFFF),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Funnel Display',
                                    color:
                                        FlutterFlowTheme.of(context).secondary,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                              elevation: 0,
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).secondary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
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
      ),
    );
  }
}
