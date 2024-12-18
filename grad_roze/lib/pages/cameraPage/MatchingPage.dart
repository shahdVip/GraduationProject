import 'package:flutter/material.dart';
import 'package:grad_roze/components/explore_card/explore_card_widget.dart';
import 'package:grad_roze/custom/theme.dart';
import 'package:grad_roze/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MatchingPageWidget extends StatefulWidget {
  final String username;
  final String color; // Pass the color for matching

  const MatchingPageWidget(
      {super.key, required this.color, required this.username});

  @override
  State<MatchingPageWidget> createState() => _MatchingPageWidgetState();
}

class _MatchingPageWidgetState extends State<MatchingPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Search-related properties
  bool isSearching = false;
  List<dynamic> allItems = [];
  List<dynamic> filteredAllItems = [];

  // Fetch items by color from the backend
  Future<List<dynamic>> fetchItemsByColor(String color) async {
    final response = await http.get(Uri.parse('$url/item/items/color/$color'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Parse and return the items
    } else if (response.statusCode == 404) {
      return []; // Return an empty list if no items are found
    } else {
      throw Exception('Failed to load items by color: ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();

    // Fetch items when the page is initialized
    fetchItemsByColor(widget.color).then((items) {
      setState(() {
        allItems = items;
        filteredAllItems = items; // Initially display all items
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: true,
        title: Text(
          'Matches for ${widget.color}', // Dynamic title based on color
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Funnel Display',
                color: FlutterFlowTheme.of(context).primary,
                letterSpacing: 0.0,
                useGoogleFonts: false,
              ),
        ),
        elevation: 0,
        iconTheme: IconThemeData(
          color: FlutterFlowTheme.of(context).primary,
        ),
      ),
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    isSearching = true; // Enable search mode
                    filteredAllItems = allItems.where((item) {
                      return item['name']
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          (item['flowerType'] as List<dynamic>).any(
                              (flowerType) => flowerType
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) ||
                          (item['tags'] as List<dynamic>).any((tag) =>
                              tag.toLowerCase().contains(value.toLowerCase()));
                    }).toList();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Search matches...',
                  labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
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
                  contentPadding:
                      const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                  prefixIcon: Icon(
                    Icons.search,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  suffixIcon: isSearching
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              isSearching = false; // Disable search mode
                              filteredAllItems = allItems; // Reset to all items
                            });
                          },
                          child: Icon(
                            Icons.clear,
                            color: FlutterFlowTheme.of(context).secondaryText,
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
              ),
            ),
            // Display items
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: fetchItemsByColor(widget.color),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No matches available'));
                  } else {
                    final items = isSearching ? filteredAllItems : allItems;

                    return GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ExploreCardWidget(
                          item: {
                            'id': item['_id'] ?? '',
                            'name': item['name'] ?? 'No Name',
                            'flowerType': (item['flowerType'] as List<dynamic>?)
                                    ?.join(', ') ??
                                'Unknown',
                            'tags':
                                (item['tags'] as List<dynamic>?)?.join(', ') ??
                                    'No Tags',
                            'imageURL': item['imageURL'] ?? '',
                            'description': item['description'] ??
                                'No Description Available',
                            'business': item['business'] ?? 'Unknown Business',
                            'color':
                                (item['color'] as List<dynamic>?)?.join(', ') ??
                                    'Unknown Color',
                            'wrapColor': (item['wrapColor'] as List<dynamic>?)
                                    ?.join(', ') ??
                                'No Wrap Color',
                            'price': item['price']?.toString() ?? '0',
                            'careTips':
                                item['careTips'] ?? 'No Care Tips Provided',
                            'rating': item['rating']?.toString() ?? 'No Rating',
                          },
                          username: widget.username,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
