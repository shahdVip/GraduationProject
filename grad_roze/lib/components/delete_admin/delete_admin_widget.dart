import 'package:grad_roze/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import 'delete_admin_model.dart';
export 'delete_admin_model.dart';

class DeleteAdminWidget extends StatefulWidget {
  const DeleteAdminWidget({super.key});

  @override
  State<DeleteAdminWidget> createState() => _DeleteAdminWidgetState();
}

class _DeleteAdminWidgetState extends State<DeleteAdminWidget> {
  late DeleteAdminModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  String? errorMessage; // Holds the error message for the TextField

  // Function to handle deleting the admin
  Future<void> deleteAdmin() async {
    final username = _model.shortBioTextController?.text;

    // Check if the username is empty
    if (username == null || username.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a username';
      });
      return;
    }

    // Retrieve the token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      setState(() {
        errorMessage = 'Unauthorized: No token found';
      });
      return;
    }

    final url = Uri.parse(deleteAdminUrl); // Update with your API URL

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Include the JWT token in the header
        },
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode == 200) {
        _model.shortBioTextController?.clear();

        // Clear the error message and reset the TextField if successful
        setState(() {
          errorMessage = null;
        });
        Navigator.pop(context);
      } else {
        // Set the error message if deletion fails
        setState(() {
          errorMessage = response.body;
        });
      }
    } catch (e) {
      // Set the error message for any exceptions
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DeleteAdminModel());

    _model.shortBioTextController ??= TextEditingController();
    _model.shortBioFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 5.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Container(
        width: double.infinity,
        height: 300.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 12.0, 0.0, 0.0),
                    child: Container(
                      width: 50.0,
                      height: 4.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).alternate,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
              // Generated code for this Text Widget...
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 0, 0),
                child: Text(
                  'Delete Admin',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Funnel Display',
                        useGoogleFonts: false,
                        color: FlutterFlowTheme.of(context).primary,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 0.0, 0.0),
                child: Text(
                  'Delete an admin by username',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Funnel Display',
                        useGoogleFonts: false,
                        letterSpacing: 0.0,
                      ),
                ),
              ),

              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _model.shortBioTextController,
                    focusNode: _model.shortBioFocusNode,
                    onChanged: (_) => EasyDebounce.debounce(
                      '_model.shortBioTextController',
                      const Duration(milliseconds: 2000),
                      () => safeSetState(() {}),
                    ),
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle:
                          FlutterFlowTheme.of(context).labelMedium.override(
                                fontFamily: 'Funnel Display',
                                useGoogleFonts: false,
                                fontSize: 16,
                                letterSpacing: 0.0,
                              ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primary,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      errorText: errorMessage, // Display the error message

                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      filled: true,
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(0, 16, 16, 8),
                      prefixIcon: Icon(
                        Icons.person_outlined,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      suffixIcon: _model.shortBioTextController!.text.isNotEmpty
                          ? InkWell(
                              onTap: () async {
                                _model.shortBioTextController?.clear();
                                safeSetState(() {});
                              },
                              child: const Icon(
                                Icons.clear,
                                color: Color(0xFF757575),
                                size: 22,
                              ),
                            )
                          : null,
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Funnel Display',
                          useGoogleFonts: false,
                          color: FlutterFlowTheme.of(context).primary,
                          fontSize: 16,
                          letterSpacing: 0.0,
                        ),
                    cursorColor: FlutterFlowTheme.of(context).primary,
                    validator: _model.shortBioTextControllerValidator
                        .asValidator(context),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Generated code for this Button Widget...
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: FFButtonWidget(
                      onPressed: () {
                        deleteAdmin();
                      },
                      text: 'Delete Admin',
                      icon: const FaIcon(
                        FontAwesomeIcons.trashAlt,
                        size: 15,
                      ),
                      options: FFButtonOptions(
                        width: 270,
                        height: 50,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        iconPadding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: const Color(0x00FFFFFF),
                        textStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Funnel Display',
                                  useGoogleFonts: false,
                                  color: FlutterFlowTheme.of(context).primary,
                                  letterSpacing: 0.0,
                                  decoration: TextDecoration.underline,
                                ),
                        elevation: 0,
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 0,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
