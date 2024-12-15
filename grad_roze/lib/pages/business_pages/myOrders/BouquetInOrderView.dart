import 'package:grad_roze/config.dart';

import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BouquetInOrderViewWidget extends StatefulWidget {
  final String bouquetId;

  const BouquetInOrderViewWidget({super.key, required this.bouquetId});

  @override
  State<BouquetInOrderViewWidget> createState() =>
      _BouquetInOrderViewWidgetState();
}

class _BouquetInOrderViewWidgetState extends State<BouquetInOrderViewWidget> {
  Map<String, dynamic>? bouquetDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBouquetDetails();
  }

  Future<void> fetchBouquetDetails() async {
    final String urlAPI = '$url/item/items/${widget.bouquetId}';

    try {
      final response = await http.get(Uri.parse(urlAPI));
      if (response.statusCode == 200) {
        setState(() {
          bouquetDetails = json.decode(response.body);
          isLoading = false;
        });
      } else {
        print('Failed to fetch bouquet details: ${response.body}');
      }
    } catch (e) {
      print('Error fetching bouquet details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          body: isLoading || bouquetDetails == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  top: true,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Image Section
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: Image.network(
                                '$url${bouquetDetails?['imageURL']}' ?? '',
                                width: double.infinity,
                                height: 280,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20, 20, 0, 0),
                              child: Row(
                                children: [
                                  FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    buttonSize: 40,
                                    fillColor: Colors.transparent,
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Content Section
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 12, 16, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Business Name
                              Text(
                                bouquetDetails?['business'] ?? 'Business Name',
                                style: FlutterFlowTheme.of(context).labelSmall,
                              ),
                              const SizedBox(height: 8),

                              // Bouquet Name
                              Text(
                                bouquetDetails?['name'] ?? 'Bouquet Name',
                                style:
                                    FlutterFlowTheme.of(context).headlineLarge,
                              ),
                              const SizedBox(height: 8),

                              // Description
                              Text(
                                bouquetDetails?['description'] ??
                                    'This bouquet has no description.',
                                style: FlutterFlowTheme.of(context).labelMedium,
                              ),
                              const SizedBox(height: 16),

                              // Rating
                              RatingBarIndicator(
                                rating:
                                    (bouquetDetails?['rating'] ?? 0).toDouble(),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star_rounded,
                                  color: FlutterFlowTheme.of(context).success,
                                ),
                                itemCount: 5,
                                itemSize: 24,
                                unratedColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                              ),
                              const SizedBox(height: 16),

                              Divider(
                                thickness: 1,
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                              const SizedBox(height: 16),

                              // Tags
                              const Text(
                                'Tags:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                children: (bouquetDetails?['tags']
                                            as List<dynamic>?)
                                        ?.map((tag) => FFButtonWidget(
                                              onPressed: () {},
                                              text: tag,
                                              options: FFButtonOptions(
                                                height: 25,
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(16, 0, 16, 0),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall,
                                                elevation: 0,
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ))
                                        .toList() ??
                                    [const Text('No tags available')],
                              ),
                              const SizedBox(height: 16),

                              // Colors
                              const Text(
                                'Colors:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                children: (bouquetDetails?['color']
                                            as List<dynamic>?)
                                        ?.map((color) => FFButtonWidget(
                                              onPressed: () {},
                                              text: color,
                                              options: FFButtonOptions(
                                                height: 25,
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(16, 0, 16, 0),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall,
                                                elevation: 0,
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ))
                                        .toList() ??
                                    [const Text('No colors available')],
                              ),
                              const SizedBox(height: 16),

                              // Types
                              const Text(
                                'Types:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                children: (bouquetDetails?['flowerType']
                                            as List<dynamic>?)
                                        ?.map((type) => FFButtonWidget(
                                              onPressed: () {},
                                              text: type,
                                              options: FFButtonOptions(
                                                height: 25,
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(16, 0, 16, 0),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall,
                                                elevation: 0,
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ))
                                        .toList() ??
                                    [const Text('No types available')],
                              ),
                              const SizedBox(height: 16),

                              // Care Tips
                              const Text(
                                'Care Tips:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  bouquetDetails?['careTips'] ??
                                      'No care tips available.',
                                  style:
                                      FlutterFlowTheme.of(context).labelMedium,
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
      ),
    );
  }
}
