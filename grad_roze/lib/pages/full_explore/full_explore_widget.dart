import 'dart:convert';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:grad_roze/config.dart';
import 'package:grad_roze/custom/animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/components/explore_card/explore_card_widget.dart';
import '/custom/choice_chips.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import '/custom/form_field_controller.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'full_explore_model.dart';
export 'full_explore_model.dart';

class ViewMoreExploreWidget extends StatefulWidget {
  const ViewMoreExploreWidget({super.key});

  @override
  State<ViewMoreExploreWidget> createState() => _ViewMoreExploreWidgetState();
}

class _ViewMoreExploreWidgetState extends State<ViewMoreExploreWidget> {
  late ViewMoreExploreModel _model;
  late Future<List<String>> _flowerTypesFuture;

  String? _selectedFlowerType;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};

  List<dynamic> recommendedItems = [];
  List<dynamic> allItems = []; // Store all items fetched from the API
  List<dynamic> filteredAllItems = []; // Store the filtered search results
  bool isSearching = false; // Flag to track if the user is searching

  String username = '';

  late Future<List<Map<String, dynamic>>> recommendationsFuture;

  @override
  void initState() {
    super.initState();

    animationsMap.addAll({
      'textFieldOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(20.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'rowOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(20.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'gridViewOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 20.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    _model = createModel(context, () => ViewMoreExploreModel());
    _getUsernameFromSharedPreferences(); // Initialize username first
    // Fetch all items when the widget is initialized
    fetchItems().then((items) {
      setState(() {
        allItems = items;
        filteredAllItems = items; // Initially show all items
      });
      print('Fetched Items: $items');
    });

    _flowerTypesFuture = _model.fetchFlowerTypes();

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<List<dynamic>> fetchItems() async {
    final response = await http.get(Uri.parse(fetchAllItemsUrl));

    if (response.statusCode == 200) {
      // Parse the response and return the list of items
      List<dynamic> fetchedItems = jsonDecode(response.body);
      return fetchedItems;
    } else {
      throw Exception('Failed to load items');
    }
  }

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
    if (username.isEmpty)
      return; // Prevent making the API call if username is empty

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
      print('Recommended Items: $recommendedItems');
    } else {
      // Handle error
      print('Failed to fetch recommended items');
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter based on user preferences and choice chip values
    List<dynamic> filteredItems = recommendedItems.where((item) {
      final flowerTypes = (item['item']?['flowerType'] as List<dynamic>? ?? []);

      // Include all items if "All" is selected
      if (_model.choiceChipsValues?.contains('All') ?? false) {
        return true;
      }

      // Exclude items with empty or missing flowerType
      if (flowerTypes.isEmpty) {
        return false;
      }

      // Check if choiceChipsValues is null or empty before using it
      if (_model.choiceChipsValues == null ||
          _model.choiceChipsValues!.isEmpty) {
        return true; // No filters applied, include all items
      }

      // Include item if any selected type matches flowerTypes
      return _model.choiceChipsValues!.any(
        (selectedType) => flowerTypes.contains(selectedType),
      );
    }).toList();

    // Debugging output to see filtered items
    if (filteredItems.isEmpty) {
      print('No items match the selected filters.');
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primary,
              size: 30,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Explore',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Funnel Display',
                  color: FlutterFlowTheme.of(context).primary,
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                child: TextFormField(
                  controller: _model.textController,
                  focusNode: _model.textFieldFocusNode,
                  onChanged: (_) {
                    EasyDebounce.debounce(
                      '_model.textController',
                      Duration(milliseconds: 2000),
                      () {
                        setState(() {
                          isSearching = true; // Set the search flag
                          filteredAllItems = allItems.where((item) {
                            // Filter based on name, flowerType, and color
                            return item['name'].toLowerCase().contains(_model
                                    .textController!.text
                                    .toLowerCase()) ||
                                (item['flowerType'] as List<dynamic>).any(
                                    (flowerType) => flowerType
                                        .toLowerCase()
                                        .contains(_model.textController!.text
                                            .toLowerCase())) ||
                                (item['color'] as List<dynamic>).any((color) =>
                                    color.toLowerCase().contains(
                                        _model.textController!.text.toLowerCase()));
                          }).toList();
                        });
                      },
                    );
                  },
                  autofocus: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Search bouqets...',
                    labelStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              fontFamily: 'Funnel Display',
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                    hintStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              fontFamily: 'Funnel Display',
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                    prefixIcon: Icon(
                      Icons.search,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    suffixIcon: _model.textController!.text.isNotEmpty
                        ? InkWell(
                            onTap: () async {
                              _model.textController?.clear();
                              setState(() {
                                isSearching = false;
                                filteredAllItems =
                                    allItems; // Reset to showing all items when cleared
                              });
                            },
                            child: Icon(
                              Icons.clear,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 22,
                            ),
                          )
                        : null,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Funnel Display',
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                  cursorColor: FlutterFlowTheme.of(context).primary,
                  validator:
                      _model.textControllerValidator.asValidator(context),
                ).animateOnPageLoad(
                    animationsMap['textFieldOnPageLoadAnimation']!),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                      child: FutureBuilder<List<String>>(
                        future: _flowerTypesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                                child: Text('No flower types available.'));
                          } else {
                            // Build the Choice Chips with fetched data
                            final flowerTypes = snapshot.data!;
                            final chipOptions = [
                              ChipData('All'),
                              ...flowerTypes.map((type) => ChipData(type)),
                            ];

                            return FlutterFlowChoiceChips(
                              options: chipOptions,
                              onChanged: (val) => setState(() {
                                _model.choiceChipsValues =
                                    val?.isEmpty ?? true ? ['All'] : val;
                              }),
                              selectedChipStyle: ChipStyle(
                                backgroundColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                                iconColor: Color(0x00000000),
                                iconSize: 0,
                                elevation: 1,
                                borderWidth: 1,
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
                                iconColor: Color(0x00000000),
                                iconSize: 0,
                                elevation: 1,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderWidth: 1,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              chipSpacing: 8,
                              rowSpacing: 12,
                              multiselect: false,
                              initialized: _model.choiceChipsValues != null,
                              alignment: WrapAlignment.start,
                              controller: _model.choiceChipsValueController ??=
                                  FormFieldController<List<String>>(['All']),
                              wrapped: true,
                            );
                          }
                        },
                      ),
                    ),
                  ]
                      .addToStart(SizedBox(width: 16))
                      .addToEnd(SizedBox(width: 16)),
                ).animateOnPageLoad(animationsMap['rowOnPageLoadAnimation']!),
              ),
              Expanded(
                child: filteredItems.isEmpty
                    ? Center(
                        child: Text(
                          'No items match the selected filters.',
                          style:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    fontFamily: 'Funnel Display',
                                    useGoogleFonts: false,
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      )
                    : Padding(
                        padding:
                            EdgeInsets.only(right: 10.0), // Add right padding
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: isSearching
                              ? filteredAllItems.length
                              : filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = isSearching
                                ? filteredAllItems[index]
                                : filteredItems[index]['item'];
                            print(item);

                            return ExploreCardWidget(
                              item: {
                                'id': item['_id'] ?? '',
                                'name': item['name'] ?? 'No Name',
                                'flowerType':
                                    (item['flowerType'] as List<dynamic>?)
                                            ?.join(', ') ??
                                        'Unknown',
                                'tags': (item['tags'] as List<dynamic>?)
                                        ?.join(', ') ??
                                    'No Tags',
                                'imageURL': item['imageURL'] ?? '',
                                'description': item['description'] ??
                                    'No Description Available',
                                'business':
                                    item['business'] ?? 'Unknown Business',
                                'color': (item['color'] as List<dynamic>?)
                                        ?.join(', ') ??
                                    'Unknown Color',
                                'wrapColor':
                                    (item['wrapColor'] as List<dynamic>?)
                                            ?.join(', ') ??
                                        'No Wrap Color',
                                'price': item['price']?.toString() ?? '0',
                                'careTips':
                                    item['careTips'] ?? 'No Care Tips Provided',
                                'rating':
                                    item['rating']?.toString() ?? 'No Rating',
                              },
                            );
                          },
                        ).animateOnPageLoad(
                            animationsMap['gridViewOnPageLoadAnimation']!),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
