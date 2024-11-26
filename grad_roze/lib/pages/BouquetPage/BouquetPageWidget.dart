import 'package:grad_roze/pages/homePage/momentPage.dart';

import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import '/config.dart' show url;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'BouquetPageModel.dart';
import '/widgets/MomentsModel.dart';

class BouquetPageWidget extends StatefulWidget {
  final String bouquetId;

  const BouquetPageWidget({super.key, required this.bouquetId});

  @override
  State<BouquetPageWidget> createState() => _BouquetPageWidgetState();
}

class _BouquetPageWidgetState extends State<BouquetPageWidget> {
  late BouquetPageModel _model;
  late MomentsModel m;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BouquetPageModel());

    // Fetch bouquet data using the model
    _model.fetchBouquetData(context, widget.bouquetId).then((_) {
      setState(() {
        // Trigger UI update after fetching data
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        // appBar: AppBar(
        //   backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        //   automaticallyImplyLeading: false,
        //   leading: IconButton(
        //     icon: Icon(Icons.arrow_back_rounded,
        //         color: FlutterFlowTheme.of(context).primaryText),
        //     onPressed: () => Navigator.of(context).pop(),
        //   ),
        //   elevation: 0,
        // ),
        body: SafeArea(
          top: true,
          child: _model.bouquetData == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0, -1),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0,
                              MediaQuery.sizeOf(context).width >= 1270.0
                                  ? 24.0
                                  : 0.0,
                              0,
                              0),
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            direction: Axis.horizontal,
                            children: [
                              // Main Content Container
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 12),
                                child: Container(
                                  width: double.infinity,
                                  constraints:
                                      const BoxConstraints(maxWidth: 570),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 3,
                                        color: Color(0x33000000),
                                        offset: Offset(0, 1),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Dynamic Image
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            child: Image.network(
                                              '$url${_model.bouquetData?['imageURL']}' ??
                                                  '',
                                              width: double.infinity,
                                              height: 280,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(Icons.broken_image,
                                                      size: 100),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 20, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(20, 0, 0, 0),
                                                  child: FlutterFlowIconButton(
                                                    borderRadius: 8,
                                                    buttonSize: 40,
                                                    fillColor:
                                                        Colors.transparent,
                                                    icon: Icon(
                                                      Icons.arrow_back,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      size: 24,
                                                    ),
                                                    onPressed: () async {
                                                      context.safePop();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Business Name
                                            Text(
                                              _model.bouquetData?['business'] ??
                                                  'Unknown Business',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .override(
                                                        fontFamily:
                                                            'Funnel Display',
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: false,
                                                      ),
                                            ),
                                            const SizedBox(
                                                height: 8), // Spacing
                                            // Bouquet Name
                                            Text(
                                              _model.bouquetData?['name'] ??
                                                  'Unknown Bouquet',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineLarge
                                                      .override(
                                                        fontFamily:
                                                            'Funnel Display',
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: false,
                                                      ),
                                            ),
                                            const SizedBox(
                                                height: 8), // Spacing
                                            // Description
                                            Text(
                                              _model.bouquetData?[
                                                      'description'] ??
                                                  'No description',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            'Funnel Display',
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: false,
                                                      ),
                                            ),
                                            const SizedBox(
                                                height: 16), // Spacing
                                            RatingBarIndicator(
                                              rating: (_model
                                                      .bouquetData?['rating']
                                                      ?.toDouble() ??
                                                  3.0), // Set the rating value
                                              itemCount: 5, // Number of stars
                                              itemSize:
                                                  30.0, // Adjust the size of the stars
                                              direction: Axis
                                                  .horizontal, // Horizontal display
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .success,
                                              ),
                                            ),
                                            // Rating Bar
                                            // RatingBar.builder(
                                            //   initialRating: (_model
                                            //           .bouquetData?['rating']
                                            //           ?.toDouble() ??
                                            //       3.0),
                                            //   minRating: 1,
                                            //   direction: Axis.horizontal,
                                            //   allowHalfRating: true,
                                            //   itemCount: 5,
                                            //   itemBuilder: (context, _) => Icon(
                                            //     Icons.star,
                                            //     color:
                                            //         FlutterFlowTheme.of(context)
                                            //             .success,
                                            //   ),
                                            //   // onRatingUpdate: (rating) {
                                            //   //   setState(() {
                                            //   //     _model.ratingBarValue =
                                            //   //         rating;
                                            //   //   });
                                            //   // },
                                            //
                                            // ),
                                            const SizedBox(
                                                height: 16), // Spacing
                                            Divider(
                                              thickness: 1,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                            const SizedBox(
                                                height: 16), // Spacing
                                            // Tags
                                            Text(
                                              'Tags:',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .override(
                                                        fontFamily:
                                                            'Funnel Display',
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: false,
                                                      ),
                                            ),
                                            const SizedBox(
                                                height: 8), // Spacing
                                            Wrap(
                                              spacing:
                                                  0, // Remove inherent spacing
                                              runSpacing:
                                                  8, // Add vertical spacing between rows
                                              children:
                                                  (_model.bouquetData?['tags']
                                                              as List<dynamic>?)
                                                          ?.map(
                                                        (tag) {
                                                          MomentsModel moment =
                                                              MomentsModel(
                                                            imageUrl:
                                                                '', // Set the imageUrl or other properties if required
                                                            text: tag,
                                                          );
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right:
                                                                        8.0), // Space between tags
                                                            child:
                                                                FFButtonWidget(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        MomentPageWidget(
                                                                            moment:
                                                                                moment),
                                                                  ),
                                                                );
                                                              },
                                                              text: tag,
                                                              options:
                                                                  FFButtonOptions(
                                                                height: 25,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                textStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      fontFamily:
                                                                          'Funnel Display',
                                                                      color: Color(
                                                                          0xFF040425),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                      useGoogleFonts:
                                                                          false,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ).toList() ??
                                                      [
                                                        const Text(
                                                            'No tags available')
                                                      ],
                                            ),

                                            const SizedBox(
                                                height: 16), // Spacing
                                            // Price
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Price',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelSmall
                                                      .override(
                                                        fontFamily:
                                                            'Funnel Display',
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: false,
                                                      ),
                                                ),
                                                Text(
                                                  '\$${_model.bouquetData?['price'] ?? 'N/A'}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .headlineMedium
                                                      .override(
                                                        fontFamily:
                                                            'Funnel Display',
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: false,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                                height: 16), // Spacing
                                            // Add to Cart Button
                                            FFButtonWidget(
                                              onPressed: () {
                                                print('Added to cart');
                                              },
                                              text: 'Add to Cart',
                                              icon: Icon(
                                                Icons.add_circle_outline,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              options: FFButtonOptions(
                                                width: double.infinity,
                                                height: 48,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                textStyle: FlutterFlowTheme.of(
                                                        context)
                                                    .titleSmall
                                                    .override(
                                                        fontFamily:
                                                            'Funnel Display',
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                        letterSpacing: 0.0,
                                                        shadows: [
                                                          Shadow(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            offset: Offset(
                                                                2.0, 2.0),
                                                            blurRadius: 2.0,
                                                          )
                                                        ],
                                                        useGoogleFonts: false),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Secondary Container (e.g., Care Tips)
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 500),
                                decoration: const BoxDecoration(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16, 0, 0, 4),
                                      child: Text(
                                        'Care Tips',
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: false,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 8), // Spacing
                                    Container(
                                      width: double.infinity,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Center(
                                          child: Text(
                                            _model.bouquetData?['careTips'] ??
                                                'No Tips',
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  fontFamily: 'Funnel Display',
                                                  color: Color(0xFF040425),
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts: false,
                                                ),
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
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
