import 'package:grad_roze/widgets/BusinessWidget/BouquetCardWidget.dart';
import 'package:grad_roze/widgets/BusinessWidget/EditBouquetWidget.dart';
import 'package:grad_roze/widgets/BusinessWidget/addBouquet.dart';

import '/custom/theme.dart';
import '/custom/util.dart';
import 'package:flutter/material.dart';
import '/config.dart' show url;
import 'package:http/http.dart' as http;
import 'my_bouquet_model.dart';
export 'my_bouquet_model.dart';

class MyBouquetWidget extends StatefulWidget {
  final String business;
  const MyBouquetWidget({super.key, required this.business});

  @override
  State<MyBouquetWidget> createState() => _MyBouquetWidgetState();
}

class _MyBouquetWidgetState extends State<MyBouquetWidget> {
  late final MyBouquetModel _model = MyBouquetModel()
    ..textFieldFocusNode = FocusNode()
    ..textControllerValidator = (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a valid value';
      }
      return null;
    };
  List<dynamic> bouquets = []; // List to hold fetched bouquets
  List<dynamic> filteredBouquets = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchBouquets();
    searchController.addListener(_filterBouquets);
  }

  @override
  void dispose() {
    _model.textFieldFocusNode?.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _filterBouquets() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredBouquets = bouquets.where((bouquet) {
        final name = (bouquet['name'] ?? '').toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  Future<void> deleteItem(String itemId) async {
    final String endpoint =
        '$url/item/delete/$itemId'; // Update with your backend URL

    try {
      final response = await http.delete(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        print('Item deleted successfully');
        setState(() {
          fetchBouquets();
          // Trigger a rebuild of the parent page
        });
        // Handle success, e.g., refresh the UI or show a message
      } else if (response.statusCode == 404) {
        print('Item not found');
        // Show a "not found" message to the user
      } else {
        print('Failed to delete item: ${response.body}');
        // Handle other response codes
      }
    } catch (error) {
      print('Error deleting item: $error');
      // Handle error (e.g., network issues)
    }
  }

  Future<void> fetchBouquets() async {
    try {
      final APIurl = Uri.parse('$url/item/business/${widget.business}');
      final response = await http.get(APIurl);

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        if (decodedBody is List) {
          setState(() {
            bouquets = decodedBody;
            filteredBouquets = decodedBody; // Initialize filtered list
          });
        } else {
          print('Unexpected response format');
        }
      } else {
        print('Failed to fetch bouquets. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching bouquets: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        floatingActionButton: FloatingActionButton(
          heroTag: 'addBouquet1',
          onPressed: () async {
            await showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              enableDrag: false,
              useSafeArea: true,
              context: context,
              builder: (context) {
                return GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Padding(
                    padding: MediaQuery.viewInsetsOf(context),
                    child: AddBouquetWidget(
                      business: widget.business,
                      onAdded: () => fetchBouquets(),
                    ),
                  ),
                );
              },
            ).then((_) => fetchBouquets());
          },
          backgroundColor: FlutterFlowTheme.of(context).primary,
          elevation: 8,
          child: Icon(
            Icons.add_rounded,
            color: FlutterFlowTheme.of(context).info,
            size: 24,
          ),
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Align(
                  alignment: const AlignmentDirectional(0, -1),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    constraints: const BoxConstraints(
                      maxWidth: 970,
                    ),
                    decoration: const BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 16, 0, 4),
                              child: Text(
                                'My Bouquets',
                                style: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                          child: Text(
                            'Below is a list of bouquets you offer',
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: 'Funnel Display',
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 8, 16, 0),
                          child: TextFormField(
                            controller: searchController,
                            focusNode: _model.textFieldFocusNode,
                            validator: _model.textControllerValidator,
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Search for a bouquets',
                              labelStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Funnel Display',
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                              hintStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
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
                                  const EdgeInsetsDirectional.fromSTEB(
                                      20, 0, 0, 0),
                              suffixIcon: Icon(
                                Icons.search_rounded,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Funnel Display',
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                            cursorColor: FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 0),
                            itemCount: filteredBouquets.length,
                            itemBuilder: (context, index) {
                              final bouquet =
                                  Bouquet.fromJson(filteredBouquets[index]);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: BouquetCardWidget(
                                  key: ValueKey(bouquet.id),
                                  bouquet: bouquet,
                                  onEdit: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditBouquetWidget(
                                            bouquetId: filteredBouquets[index]
                                                ['_id'],
                                            // Ensure this is a valid ID
                                            bouquetDetails: filteredBouquets[
                                                index], // Ensure this is a valid Map<String, dynamic>
                                            business: widget.business,
                                            onUpdated: () =>
                                                fetchBouquets(), // Callback to refresh bouquets
                                            onUpdatedrefresh: () =>
                                                setState(() {
                                                  fetchBouquets();
                                                  // Trigger a rebuild of the parent page
                                                })),
                                      ),
                                    );
                                  },
                                  onDelete: () async {
                                    print(
                                        'Delete action triggered for bouquet ${bouquet.name} ${bouquet.id}');
                                    try {
                                      await deleteItem(bouquet
                                          .id); // Pass the bouquet's ID to delete it
                                      print('Item deleted');
                                      // Optionally refresh the parent page or list
                                      setState(() {}); // Refreshes the UI
                                    } catch (e) {
                                      print('Failed to delete bouquet: $e');
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
