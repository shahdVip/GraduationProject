import 'package:grad_roze/config.dart';

import '/components/admin_user_creation_bottomsheet/admin_user_creation_bottomsheet_widget.dart';
import '/components/user_section_bus/user_section_bus_widget.dart';
import '/components/user_section_cus/user_section_cus_widget.dart';
import '/components/user_section_pending/user_section_pending_widget.dart';
import '/custom/choice_chips.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/form_field_controller.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import 'dart:convert';
import 'package:flutter/material.dart';

import 'admin_users_section_model.dart';
export 'admin_users_section_model.dart';

// Fetch all admin-approved customers
Future<List<Map<String, dynamic>>> fetchAdminApprovedCustomers() async {
  final response = await http.get(Uri.parse('$usrLstBaseUrl/customers'));
  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  } else {
    throw Exception('Failed to load customers');
  }
}

// Fetch all admin-approved businesses
Future<List<Map<String, dynamic>>> fetchAdminApprovedBusinesses() async {
  final response = await http.get(Uri.parse('$usrLstBaseUrl/businesses'));
  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  } else {
    throw Exception('Failed to load businesses');
  }
}

// Fetch all pending user requests
Future<List<Map<String, dynamic>>> fetchPendingUsers() async {
  final response = await http.get(Uri.parse(pendingUsrLstUrl));
  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  } else {
    throw Exception('Failed to load pending users');
  }
}

// Fetch all users (customers, businesses, and pending)
Future<List<Map<String, dynamic>>> fetchAllUsers() async {
  final response = await http.get(Uri.parse(allUsrLstUrl));
  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  } else {
    throw Exception('Failed to load all users');
  }
}

// class UserListView extends StatelessWidget {
//   final String role; // Role type to determine which endpoint to call

//   UserListView({required this.role});

//   Future<List<Map<String, dynamic>>> _fetchUsers() {
//     switch (role) {
//       case 'Customers':
//         return fetchAdminApprovedCustomers();
//       case 'Businesses':
//         return fetchAdminApprovedBusinesses();
//       case 'Pending':
//         return fetchPendingUsers();
//       case 'All':
//       default:
//         return fetchAllUsers();
//     }
//   }
// }

class AdminUsersSectionWidget extends StatefulWidget {
  const AdminUsersSectionWidget({
    super.key,
  });

  @override
  State<AdminUsersSectionWidget> createState() =>
      _AdminUsersSectionWidgetState();
}

class _AdminUsersSectionWidgetState extends State<AdminUsersSectionWidget> {
  late AdminUsersSectionModel _model;
  String _searchTerm = '';

  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<Map<String, dynamic>>> _fetchUsers() {
    // Use the choiceChipsValue to decide which set of users to fetch
    switch (_model.choiceChipsValue) {
      case 'Customers  ':
        return fetchAdminApprovedCustomers();
      case 'Businesses  ':
        return fetchAdminApprovedBusinesses();
      case 'Pending  ':
        return fetchPendingUsers();
      case 'All  ':
      default:
        return fetchAllUsers();
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminUsersSectionModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
              await showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                enableDrag: false,
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: const AdminUserCreationBottomsheetWidget(),
                    ),
                  );
                },
              ).then((value) => safeSetState(() {}));
            },
            backgroundColor: FlutterFlowTheme.of(context).primary,
            elevation: 8,
            child: Icon(
              Icons.add_rounded,
              color: FlutterFlowTheme.of(context).info,
              size: 24,
            ),
          ),
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: false,
            title: Text(
              'Users',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Funnel Display',
                    useGoogleFonts: false,
                    color: FlutterFlowTheme.of(context).primary,
                    letterSpacing: 0.0,
                  ),
            ),
            actions: const [],
            centerTitle: false,
            elevation: 0,
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
                            if (responsiveVisibility(
                              context: context,
                              phone: false,
                              tablet: false,
                            ))
                              Container(
                                width: double.infinity,
                                height: 24,
                                decoration: const BoxDecoration(),
                              ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 0, 0, 0),
                              child: Text(
                                'Below are a list of users.',
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      useGoogleFonts: false,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                            // Generated code for this TextField Widget...
                            // Generated code for this TextField Widget...
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                              child: TextFormField(
                                controller: _model.textController,
                                focusNode: _model.textFieldFocusNode,
                                onChanged: (_) {
                                  EasyDebounce.debounce(
                                    '_model.textController',
                                    Duration(milliseconds: 1000),
                                    () {
                                      setState(() {
                                        _searchTerm =
                                            _model.textController?.text ?? '';
                                      });
                                    },
                                  );
                                },
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Search all users...',
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Funnel Display',
                                        useGoogleFonts: false,
                                        letterSpacing: 0.0,
                                      ),
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Funnel Display',
                                        useGoogleFonts: false,
                                        letterSpacing: 0.0,
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
                                      EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                  suffixIcon: _model
                                          .textController!.text.isNotEmpty
                                      ? InkWell(
                                          onTap: () async {
                                            _model.textController?.clear();
                                            setState(() {
                                              _searchTerm =
                                                  ''; // Clear the search term
                                            });
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 22,
                                          ),
                                        )
                                      : null,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Funnel Display',
                                      useGoogleFonts: false,
                                      letterSpacing: 0.0,
                                    ),
                                cursorColor:
                                    FlutterFlowTheme.of(context).primary,
                                validator: _model.textControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 8, 0, 8),
                                    child: FlutterFlowChoiceChips(
                                      options: const [
                                        ChipData('All  '),
                                        ChipData('Pending  '),
                                        ChipData('Customers  '),
                                        ChipData('Businesses  ')
                                      ],
                                      onChanged: (val) => safeSetState(() =>
                                          _model.choiceChipsValue =
                                              val?.firstOrNull),
                                      selectedChipStyle: ChipStyle(
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              useGoogleFonts: false,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              letterSpacing: 0.0,
                                            ),
                                        iconColor: const Color(0x00000000),
                                        iconSize: 0,
                                        elevation: 2,
                                        borderWidth: 1,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      unselectedChipStyle: ChipStyle(
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .alternate,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Funnel Display',
                                              useGoogleFonts: false,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              letterSpacing: 0.0,
                                            ),
                                        iconColor: const Color(0x00000000),
                                        iconSize: 0,
                                        elevation: 2,
                                        borderColor:
                                            FlutterFlowTheme.of(context)
                                                .alternate,
                                        borderWidth: 1,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      chipSpacing: 8,
                                      rowSpacing: 12,
                                      multiselect: false,
                                      initialized:
                                          _model.choiceChipsValue != null,
                                      alignment: WrapAlignment.start,
                                      controller:
                                          _model.choiceChipsValueController ??=
                                              FormFieldController<List<String>>(
                                        ['All  '],
                                      ),
                                      wrapped: true,
                                    ),
                                  ),
                                ]
                                    .addToStart(const SizedBox(width: 16))
                                    .addToEnd(const SizedBox(width: 16)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 0, 16, 0),
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: const AlignmentDirectional(-1, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    if (responsiveVisibility(
                                      context: context,
                                      phone: false,
                                    ))
                                      Container(
                                        width: 40,
                                        height: 100,
                                        decoration: const BoxDecoration(),
                                      ),
                                    Expanded(
                                      flex: 4,
                                      child: Align(
                                        alignment:
                                            const AlignmentDirectional(-1, 0),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(16, 0, 0, 0),
                                          child: Text(
                                            'Name',
                                            style: FlutterFlowTheme.of(context)
                                                .labelSmall
                                                .override(
                                                  fontFamily: 'Funnel Display',
                                                  useGoogleFonts: false,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment:
                                                const AlignmentDirectional(
                                                    1, 0),
                                            child: Text(
                                              'Role',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .override(
                                                        fontFamily:
                                                            'Funnel Display',
                                                        useGoogleFonts: false,
                                                        letterSpacing: 0.0,
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
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: _fetchUsers(),
                              builder: (context, snapshot) {
                                // Show loading indicator while data is being fetched
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                // Show error if fetching fails
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                }

                                // If no data is received
                                if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                      child: Text('No data available'));
                                }

                                // Get the list of users based on the role
                                List<Map<String, dynamic>> users = snapshot
                                    .data!
                                    .where((user) => user['username']
                                        .toLowerCase()
                                        .contains(_searchTerm.toLowerCase()))
                                    .toList();

                                // Filter users based on selected choiceChipsValue
                                List<Map<String, dynamic>> filteredUsers =
                                    users.where((user) {
                                  switch (_model.choiceChipsValue) {
                                    case 'Customers':
                                      return user['role'] == 'Customer';
                                    case 'Businesses':
                                      return user['role'] == 'Business';
                                    case 'Pending':
                                      return user['role'] == 'Pending';
                                    case 'All':
                                    default:
                                      return true; // Show all users
                                  }
                                }).toList();

                                // If no users match the filter
                                if (filteredUsers.isEmpty) {
                                  return Center(
                                      child: Text('No users available '));
                                }

                                return ListView(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 44),
                                  shrinkWrap: true,
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    for (var user in filteredUsers)
                                      if (user['adminApproved'] == true &&
                                          (user['role'] == 'Customer' ||
                                              _model.choiceChipsValue == 'All'))
                                        wrapWithModel(
                                          model: _model.userSectionCusModel,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: UserSectionCusWidget(
                                              username: user['username'],
                                              email: user['email'],
                                              profilePhoto:
                                                  user['profilePhoto'],
                                              phoneNumber: user['phoneNumber'],
                                              address: user['address']),
                                        ),
                                    for (var user in filteredUsers)
                                      if (user['adminApproved'] == true &&
                                          (user['role'] == 'Business' ||
                                              _model.choiceChipsValue == 'All'))
                                        wrapWithModel(
                                          model: _model.userSectionBusModel,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: UserSectionBusWidget(
                                              username: user['username'],
                                              email: user['email'],
                                              profilePhoto:
                                                  user['profilePhoto'],
                                              phoneNumber: user['phoneNumber'],
                                              address: user['address']),
                                        ),
                                    for (var user in filteredUsers)
                                      if (user['adminApproved'] == false ||
                                          _model.choiceChipsValue == 'All')
                                        wrapWithModel(
                                          model: _model.userSectionPendingModel,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: UserSectionPendingWidget(
                                            username: user['username'],
                                            email: user['email'],
                                            profilePhoto: user['profilePhoto'],
                                          ),
                                        ),
                                  ].divide(const SizedBox(height: 1)),
                                );
                              },
                            )

                            // ListView(
                            //   padding: const EdgeInsets.fromLTRB(
                            //     0,
                            //     0,
                            //     0,
                            //     44,
                            //   ),
                            //   shrinkWrap: true,
                            //   scrollDirection: Axis.vertical,
                            //   children: [
                            //     if ((_model.choiceChipsValue == 'Customers  ') ||
                            //         (_model.choiceChipsValue == 'All  '))
                            //       wrapWithModel(
                            //         model: _model.userSectionCusModel,
                            //         updateCallback: () => safeSetState(() {}),
                            //         child: const UserSectionCusWidget(),
                            //       ),
                            //     if ((_model.choiceChipsValue == 'Businesses  ') ||
                            //         (_model.choiceChipsValue == 'All  '))
                            //       wrapWithModel(
                            //         model: _model.userSectionBusModel,
                            //         updateCallback: () => safeSetState(() {}),
                            //         child: const UserSectionBusWidget(),
                            //       ),
                            //     if ((_model.choiceChipsValue == 'Pending  ') ||
                            //         (_model.choiceChipsValue == 'All  '))
                            //       wrapWithModel(
                            //         model: _model.userSectionPendingModel,
                            //         updateCallback: () => safeSetState(() {}),
                            //         child: const UserSectionPendingWidget(),
                            //       ),
                            //   ].divide(const SizedBox(height: 1)),
                            // ),
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
