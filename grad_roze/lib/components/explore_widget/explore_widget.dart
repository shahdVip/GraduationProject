import 'dart:convert';

import 'package:grad_roze/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/components/explore_card/explore_card_widget.dart';
import '/custom/animations.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;

import 'explore_model.dart';
export 'explore_model.dart';

class ExploreWidget extends StatefulWidget {
  const ExploreWidget({super.key});

  @override
  State<ExploreWidget> createState() => _ExploreWidgetState();
}

class _ExploreWidgetState extends State<ExploreWidget>
    with TickerProviderStateMixin {
  late ExploreModel _model;
  List<dynamic> recommendedItems = [];
  String username = '';

  final animationsMap = <String, AnimationInfo>{};

  // Fetch username from SharedPreferences
  Future<void> _getUsernameFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ??
          ''; // Default to empty string if not found
    });

    if (username.isNotEmpty) {
      fetchRecommendedItems(); // Fetch recommended items once username is available
    } else {
      // Handle case where username is not available
      print('Username not found in SharedPreferences');
    }
  }

  // Fetch recommended items from the backend API
  Future<void> fetchRecommendedItems() async {
    if (username.isEmpty) {
      return; // Prevent making the API call if username is empty
    }

    final response = await http.post(
      Uri.parse(fetchPreferenceUrl), // Replace with your API endpoint
      headers: {'Content-Type': 'application/json'},
      body:
          json.encode({'username': username}), // Pass the username dynamically
    );

    if (response.statusCode == 200) {
      final List<dynamic> items = json.decode(response.body);
      setState(() {
        recommendedItems = items;
      });
    } else {
      // Handle error
      print('Failed to fetch recommended items');
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
    _getUsernameFromSharedPreferences();

    _model = createModel(context, () => ExploreModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
          TiltEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.698, 0),
            end: const Offset(0, 0),
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
      child: Container(
        width: double.infinity,
        height: 350,
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: const AlignmentDirectional(-1, 0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(-1, 0),
                      child: Text(
                        'Blossoms to Match Your Style',
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Funnel Display',
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w700,
                                  useGoogleFonts: false,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 300,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      recommendedItems.length > 5 ? 5 : recommendedItems.length,
                  itemBuilder: (context, index) {
                    final item = recommendedItems[index][
                        'item']; // Assuming your API response has an 'item' field

                    return ExploreCardWidget(item: {
                      'id':
                          item['_id'] ?? '', // Default to empty string if null
                      'name': item['name'] ??
                          'No Name', // Default value for missing name
                      'flowerType':
                          (item['flowerType'] as List<dynamic>?)?.join(', ') ??
                              'Unknown', // Join list or default
                      'tags': (item['tags'] as List<dynamic>?)?.join(', ') ??
                          'No Tags',
                      'imageURL':
                          item['imageURL'] ?? '', // Default to empty string
                      'description':
                          item['description'] ?? 'No Description Available',
                      'business': item['business'] ?? 'Unknown Business',
                      'color': (item['color'] as List<dynamic>?)?.join(', ') ??
                          'Unknown Color',
                      'wrapColor':
                          (item['wrapColor'] as List<dynamic>?)?.join(', ') ??
                              'No Wrap Color',
                      'price': item['price']?.toString() ??
                          '0', // Convert to String or default to '0'
                      'careTips': item['careTips'] ?? 'No Care Tips Provided',
                      'rating': item['rating']?.toString() ??
                          'No Rating', // Convert rating to String
                    });
// Use your ExploreCard widget to display each item
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 24),
              child: FFButtonWidget(
                onPressed: () {
                  context.pushNamed('FullExplore');
                },
                text: 'View More',
                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 15,
                ),
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 40,
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  iconAlignment: IconAlignment.end,
                  iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  color: const Color(0x00040425),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                      color: FlutterFlowTheme.of(context).secondary,
                      fontSize: 14,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      useGoogleFonts: false),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ],
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
    );
  }
}




// Container(
//               width: double.infinity,
//               height: 300,
//               decoration: BoxDecoration(
//                 color: Color(0x00FFFFFF),
//               ),
//               child: recommendedItems.isEmpty
//                   ? Center(
//                       child:
//                           CircularProgressIndicator()) // Show loading spinner if no data
//                   : ListView.builder(
//                       padding: EdgeInsets.zero,
//                       shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       itemCount: recommendedItems.length > 5
//                           ? 5
//                           : recommendedItems.length,
//                       itemBuilder: (context, index) {
//                         final item = recommendedItems[index][
//                             'item']; // Assuming your API response has an 'item' field

//                         return ExploreCardWidget(item: {
//                           'id': item['_id'] ??
//                               '', // Default to empty string if null
//                           'name': item['name'] ??
//                               'No Name', // Default value for missing name
//                           'flowerType': (item['flowerType'] as List<dynamic>?)
//                                   ?.join(', ') ??
//                               'Unknown', // Join list or default
//                           'tags':
//                               (item['tags'] as List<dynamic>?)?.join(', ') ??
//                                   'No Tags',
//                           'imageURL':
//                               item['imageURL'] ?? '', // Default to empty string
//                           'description':
//                               item['description'] ?? 'No Description Available',
//                           'business': item['business'] ?? 'Unknown Business',
//                           'color':
//                               (item['color'] as List<dynamic>?)?.join(', ') ??
//                                   'Unknown Color',
//                           'wrapColor': (item['wrapColor'] as List<dynamic>?)
//                                   ?.join(', ') ??
//                               'No Wrap Color',
//                           'price': item['price']?.toString() ??
//                               '0', // Convert to String or default to '0'
//                           'careTips':
//                               item['careTips'] ?? 'No Care Tips Provided',
//                           'rating': item['rating']?.toString() ??
//                               'No Rating', // Convert rating to String
//                         });
// // Use your ExploreCard widget to display each item
//                       },
//                     ),

//             ),