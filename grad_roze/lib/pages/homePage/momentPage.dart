import 'package:flutter/material.dart';
import 'package:grad_roze/components/explore_card/explore_card_widget.dart';
import 'package:grad_roze/custom/theme.dart';
import 'package:grad_roze/config.dart';
import 'package:grad_roze/widgets/Bouquet/BouquetViewWidget.dart';
import '../../widgets/MomentsModel.dart';
export '../../widgets/MomentsModel.dart';

import '/custom/util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'momentPage_model.dart';
export 'momentPage_model.dart';

class MomentPageWidget extends StatefulWidget {
  final MomentsModel moment;

  const MomentPageWidget({super.key, required this.moment});

  @override
  State<MomentPageWidget> createState() => _MomentPageWidgetState();
}

class _MomentPageWidgetState extends State<MomentPageWidget> {
  late MomentPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Add the flag and collections
  bool isSearching = false;
  List<dynamic> allItems = [];
  List<dynamic> filteredAllItems = [];
  @override
  void initState() {
    super.initState();

    // Initialize the model
    _model = MomentPageModel();

    // Initialize text controllers
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    // Fetch items and bouquets after initializing the model
    fetchItems().then((items) {
      setState(() {
        allItems = items;
        filteredAllItems = items; // Initially show all items
      });
    });

    _futureBouquets = fetchBouquets();
  }

  late Future<List<BouquetViewModel>> _futureBouquets;

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

  Future<List<BouquetViewModel>> fetchBouquets() async {
    try {
      final response = await http.get(
        Uri.parse(
          '$url/item/items/tag/${widget.moment.text}',
        ),
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);

        // Return an empty list if the response is empty or invalid
        if (jsonResponse.isEmpty) {
          return [];
        }

        return jsonResponse
            .map((data) => BouquetViewModel.fromJson(data))
            .toList();
      } else {
        print('Failed to load bouquets: Status Code ${response.statusCode}');
        print('Response body: ${response.body}');
        return []; // Return empty list instead of throwing an exception
      }
    } catch (e) {
      print('Error fetching bouquets: $e');
      return []; // Return empty list in case of any error
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
          widget.moment.text,
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
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
              child: TextFormField(
                controller: _model.textController,
                focusNode: _model.textFieldFocusNode,
                onChanged: (_) {
                  EasyDebounce.debounce(
                    '_model.textController',
                    const Duration(milliseconds: 2000),
                    () {
                      setState(() {
                        isSearching = true; // Set the search flag
                        filteredAllItems = allItems.where((item) {
                          return item['name'].toLowerCase().contains(
                                  _model.textController!.text.toLowerCase()) ||
                              (item['flowerType'] as List<dynamic>).any(
                                  (flowerType) => flowerType
                                      .toLowerCase()
                                      .contains(_model.textController!.text
                                          .toLowerCase())) ||
                              (item['color'] as List<dynamic>).any((color) =>
                                  color.toLowerCase().contains(_model
                                      .textController!.text
                                      .toLowerCase()));
                        }).toList();
                      });
                    },
                  );
                },
                autofocus: false,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Search bouqets...',
                  labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Funnel Display',
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                  hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
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
                  contentPadding:
                      const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
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
                validator: _model.textControllerValidator.asValidator(context),
              ),
            ),
            FutureBuilder<List<BouquetViewModel>>(
              future: _futureBouquets,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No bouquets available'));
                } else {
                  final bouquets = snapshot.data!;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: isSearching
                          ? GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                childAspectRatio: 0.7,
                              ),
                              itemCount: filteredAllItems.length,
                              itemBuilder: (context, index) {
                                final item = filteredAllItems[index];

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
                                    'careTips': item['careTips'] ??
                                        'No Care Tips Provided',
                                    'rating': item['rating']?.toString() ??
                                        'No Rating',
                                  },
                                );
                              },
                            )
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                childAspectRatio: 0.7,
                              ),
                              itemCount: bouquets
                                  .length, // Display filtered or all items
                              itemBuilder: (context, index) {
                                final item = bouquets[index];
                                return BouquetViewWidget(
                                    model:
                                        item); // Display either search result or all items
                              },
                            ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// class _MomentPageWidgetState extends State<MomentPageWidget> {
//   late MomentPageModel _model;
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   @override
//   void initState() {
//     super.initState();

//     // Initialize the model
//     _model = MomentPageModel();

//     // Initialize text controllers
//     _model.textController ??= TextEditingController();
//     _model.textFieldFocusNode ??= FocusNode();

//     // Fetch items and bouquets after initializing the model
//     fetchItems().then((items) {
//       setState(() {
//         allItems = items;
//         filteredAllItems = items; // Initially show all items
//       });
//     });

//     _futureBouquets = fetchBouquets();
//   }

//   late Future<List<BouquetViewModel>> _futureBouquets;
//   List<dynamic> allItems = []; // Store all items fetched from the API
//   List<dynamic> filteredAllItems = []; // Store the filtered search results
//   bool isSearching = false; // Flag to track if the user is searching
//   Future<List<dynamic>> fetchItems() async {
//     final response = await http.get(Uri.parse(fetchAllItemsUrl));

//     if (response.statusCode == 200) {
//       // Parse the response and return the list of items
//       List<dynamic> fetchedItems = jsonDecode(response.body);
//       return fetchedItems;
//     } else {
//       throw Exception('Failed to load items');
//     }
//   }

//   Future<List<BouquetViewModel>> fetchBouquets() async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//           '$url/item/items/tag/${widget.moment.text}',
//         ),
//       );

//       if (response.statusCode == 200) {
//         List jsonResponse = json.decode(response.body);

//         // Return an empty list if the response is empty or invalid
//         if (jsonResponse.isEmpty) {
//           return [];
//         }

//         return jsonResponse
//             .map((data) => BouquetViewModel.fromJson(data))
//             .toList();
//       } else {
//         print('Failed to load bouquets: Status Code ${response.statusCode}');
//         print('Response body: ${response.body}');
//         return []; // Return empty list instead of throwing an exception
//       }
//     } catch (e) {
//       print('Error fetching bouquets: $e');
//       return []; // Return empty list in case of any error
//     }
//   }

//   @override
//   void dispose() {
//     _model.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_model == null) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     return Scaffold(
//       key: scaffoldKey,
//       backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
//       appBar: AppBar(
//         backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
//         automaticallyImplyLeading: true,
//         title: Text(
//           widget.moment.text, // Use the moment's name here
//           style: FlutterFlowTheme.of(context).displaySmall.override(
//                 fontFamily: 'Funnel Display',
//                 letterSpacing: 0.0,
//                 useGoogleFonts: false,
//               ),
//         ),
//         elevation: 0,
//         iconTheme: IconThemeData(
//           color:
//               FlutterFlowTheme.of(context).primary, // Set the back icon color
//         ),
//       ),
//       body: SafeArea(
//         top: true,
//         child: Column(
//             mainAxisSize: MainAxisSize.max,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
//                 child: TextFormField(
//                   controller: _model.textController,
//                   focusNode: _model.textFieldFocusNode,
//                   onChanged: (_) {
//                     EasyDebounce.debounce(
//                       '_model.textController',
//                       Duration(milliseconds: 2000),
//                       () {
//                         setState(() {
//                           isSearching = true; // Set the search flag
//                           filteredAllItems = allItems.where((item) {
//                             // Filter based on name, flowerType, and color
//                             return item['name'].toLowerCase().contains(_model
//                                     .textController!.text
//                                     .toLowerCase()) ||
//                                 (item['flowerType'] as List<dynamic>).any(
//                                     (flowerType) => flowerType
//                                         .toLowerCase()
//                                         .contains(_model.textController!.text
//                                             .toLowerCase())) ||
//                                 (item['color'] as List<dynamic>).any((color) =>
//                                     color.toLowerCase().contains(
//                                         _model.textController!.text.toLowerCase()));
//                           }).toList();
//                         });
//                       },
//                     );
//                   },
//                   autofocus: false,
//                   obscureText: false,
//                   decoration: InputDecoration(
//                     labelText: 'Search bouqets...',
//                     labelStyle:
//                         FlutterFlowTheme.of(context).labelMedium.override(
//                               fontFamily: 'Funnel Display',
//                               letterSpacing: 0.0,
//                               useGoogleFonts: false,
//                             ),
//                     hintStyle:
//                         FlutterFlowTheme.of(context).labelMedium.override(
//                               fontFamily: 'Funnel Display',
//                               letterSpacing: 0.0,
//                               useGoogleFonts: false,
//                             ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: FlutterFlowTheme.of(context).alternate,
//                         width: 2,
//                       ),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: FlutterFlowTheme.of(context).primary,
//                         width: 2,
//                       ),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: FlutterFlowTheme.of(context).error,
//                         width: 2,
//                       ),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     focusedErrorBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: FlutterFlowTheme.of(context).error,
//                         width: 2,
//                       ),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     contentPadding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
//                     prefixIcon: Icon(
//                       Icons.search,
//                       color: FlutterFlowTheme.of(context).secondaryText,
//                     ),
//                     suffixIcon: _model.textController!.text.isNotEmpty
//                         ? InkWell(
//                             onTap: () async {
//                               _model.textController?.clear();
//                               setState(() {
//                                 isSearching = false;
//                                 filteredAllItems =
//                                     allItems; // Reset to showing all items when cleared
//                               });
//                             },
//                             child: Icon(
//                               Icons.clear,
//                               color: FlutterFlowTheme.of(context).secondaryText,
//                               size: 22,
//                             ),
//                           )
//                         : null,
//                   ),
//                   style: FlutterFlowTheme.of(context).bodyMedium.override(
//                         fontFamily: 'Funnel Display',
//                         letterSpacing: 0.0,
//                         useGoogleFonts: false,
//                       ),
//                   cursorColor: FlutterFlowTheme.of(context).primary,
//                   validator:
//                       _model.textControllerValidator.asValidator(context),
//                 ),
//               ),
//               FutureBuilder<List<BouquetViewModel>>(
//                 future: _futureBouquets,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(child: Text('No bouquets available'));
//                   } else {
//                     final bouquets = snapshot.data!;
//                     return Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: GridView.builder(
//                           gridDelegate:
//                               const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2, // Number of items per row
//                             crossAxisSpacing: 8.0, // Spacing between columns
//                             mainAxisSpacing: 8.0, // Spacing between rows
//                             childAspectRatio: 0.7, // Aspect ratio for each item
//                           ),
//                           itemCount: bouquets.length,
//                           itemBuilder: (context, index) {
//                             final bouquet = bouquets[index];
//                             return BouquetViewWidget(
//                                 model:
//                                     bouquet); // Use BouquetViewWidget for each grid item
//                           },
//                         ),
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ]),
//       ),
//     );
//   }
// }
