import 'package:grad_roze/components/business_components/inventory_comp/flower_in_inventory_card/flower_in_inventory_card_widget.dart';
import 'package:grad_roze/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/business_components/inventory_comp/add_in_inventory/add_in_inventory_widget.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'inventory_model.dart';
export 'inventory_model.dart';

class InventoryWidget extends StatefulWidget {
  const InventoryWidget({super.key});

  @override
  State<InventoryWidget> createState() => _InventoryWidgetState();
}

class _InventoryWidgetState extends State<InventoryWidget> {
  late InventoryModel _model;
  late Future<List<dynamic>> _flowersFuture =
      Future.value([]); // Default to empty list

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSearching = false; // Track search state

  @override
  void initState() {
    super.initState();
    _loadData();

    _model = createModel(context, () => InventoryModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textController?.addListener(() {
      String query = _model.textController?.text ?? '';
      if (query.isNotEmpty) {
        setState(() {
          _isSearching = true; // User is typing a query
        });
        _loadData(query); // Trigger search with query
      } else {
        setState(() {
          _isSearching = false; // User cleared the search
        });
        _loadData(); // Reload all flowers
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _loadData([String? query]) async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    if (username != null) {
      setState(() {
        // If there's a search query, search inventory; otherwise, fetch all flowers
        _flowersFuture = query == null || query.isEmpty
            ? fetchFlowers(username) // Load full inventory
            : searchInventory(username, query); // Perform search
      });
    } else {
      setState(() {
        _flowersFuture =
            Future.value([]); // If username is not found, return an empty list
      });
    }
  }

  Future<List<dynamic>> searchInventory(String username, String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$url/inventory/$username/search?keyword=$query'), // Include search query
      );
      if (response.statusCode == 200) {
        return json.decode(response.body)['flowers'];
      } else {
        throw Exception('Failed to search inventory');
      }
    } catch (e) {
      throw Exception('Error searching inventory: $e');
    }
  }

  Future<List<dynamic>> fetchFlowers(String username) async {
    final response = await http.get(
      Uri.parse('$url/inventory/$username'), // Update with your API URL
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['flowers']; // Ensure 'flowers' matches your API response.
    } else {
      throw Exception('Failed to load flowers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              bool? shouldRefresh = await showModalBottomSheet(
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
                      child: const AddInInventoryWidget(),
                    ),
                  );
                },
              ).then((value) => value);
              if (shouldRefresh ?? false) {
                // If the flower was added successfully, refresh the flowers list
                _loadData(); // Call the method to refresh the data
              }
            },
            backgroundColor: FlutterFlowTheme.of(context).secondary,
            elevation: 8,
            child: Icon(
              Icons.add_rounded,
              color: FlutterFlowTheme.of(context).info,
              size: 24,
            ),
          ),
          body: SafeArea(
            top: true,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Align(
                    alignment: const AlignmentDirectional(0, -1),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 970,
                      ),
                      decoration: const BoxDecoration(),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 16, 0, 0),
                                  child: FlutterFlowIconButton(
                                    borderRadius: 8,
                                    icon: Icon(
                                      Icons.clear_all_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      size: 35,
                                    ),
                                    onPressed: () async {
                                      scaffoldKey.currentState!.openDrawer();
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      4, 16, 0, 4),
                                  child: Text(
                                    'Inventory',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .override(
                                          fontFamily: 'Funnel Display',
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 0, 0, 0),
                              child: Text(
                                'Below are a list of flowers in your inventory.',
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
                                controller: _model.textController,
                                focusNode: _model.textFieldFocusNode,
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Search all inventory',
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
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
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
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      letterSpacing: 0.0,
                                      useGoogleFonts: false,
                                    ),
                                cursorColor:
                                    FlutterFlowTheme.of(context).primary,
                                validator: _model.textControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 0),
                              child: FutureBuilder<List<dynamic>>(
                                future: _flowersFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                        child: Text('No flowers in inventory'));
                                  }

                                  final flowers = snapshot.data!;
                                  return ListView.builder(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 44),
                                    shrinkWrap: true,
                                    itemCount: flowers.length,
                                    itemBuilder: (context, index) {
                                      final flower = flowers[index];
                                      return FlowerInInventoryCardWidget(
                                        flowerData: flower,
                                        refreshFlowers:
                                            _loadData, // Pass the refresh function
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
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
