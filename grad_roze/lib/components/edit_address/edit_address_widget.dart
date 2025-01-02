import 'package:grad_roze/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'edit_address_model.dart';
export 'edit_address_model.dart';

class EditAddressWidget extends StatefulWidget {
  const EditAddressWidget({super.key});

  @override
  State<EditAddressWidget> createState() => _EditAddressWidgetState();
}

class _EditAddressWidgetState extends State<EditAddressWidget> {
  late EditAddressModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  String? errorMessage; // Declare a variable for the error message

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditAddressModel());

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
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
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
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                    child: Container(
                      width: 50,
                      height: 4,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).alternate,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 0, 0),
                child: Text(
                  'Edit Address',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Funnel Display',
                        color: FlutterFlowTheme.of(context).primary,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
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
                      labelText: 'New Address',
                      labelStyle:
                          FlutterFlowTheme.of(context).labelMedium.override(
                                fontFamily: 'Funnel Display',
                                fontSize: 16,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
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
                      errorText: errorMessage, // Display the error message

                      filled: true,
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(0, 16, 16, 8),
                      prefixIcon: Icon(
                        Icons.location_on_rounded,
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
                          fontSize: 16,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),

                    cursorColor: FlutterFlowTheme.of(context).primary,
                    validator: (_) =>
                        errorMessage, // Use the validator to show the error
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        final newAddress =
                            _model.shortBioTextController?.text.trim();

                        if (newAddress == null || newAddress.isEmpty) {
                          // Set error message if the input is invalid
                          safeSetState(() {
                            errorMessage = 'Please enter a valid address.';
                          });
                          return;
                        } else {
                          // Clear the error message
                          safeSetState(() {
                            errorMessage = null;
                          });
                        }

                        try {
                          // Fetch token from shared preferences
                          final prefs = await SharedPreferences.getInstance();
                          final token = prefs.getString('jwt_token');

                          if (token == null) {
                            safeSetState(() {
                              errorMessage = 'User is not authenticated.';
                            });
                            return;
                          }

                          // Make the HTTP PUT request
                          final response = await http.put(
                            Uri.parse('$url/update-address'),
                            headers: {
                              'Content-Type': 'application/json',
                              'Authorization': 'Bearer $token',
                            },
                            body: jsonEncode({
                              'address': newAddress,
                            }),
                          );

                          if (response.statusCode == 200) {
                            Navigator.pop(context, newAddress);
                            // Address updated successfully
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Address updated successfully!')),
                            );
                            // Optionally, clear the input field
                            _model.shortBioTextController?.clear();
                          } else {
                            Navigator.pop(context);

                            // Show error message from the backend
                            final error = jsonDecode(response.body);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(error['error'] ??
                                      'Failed to update address')),
                            );
                          }
                        } catch (error) {
                          Navigator.pop(context);

                          // Handle any other errors
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('An error occurred: $error')),
                          );
                        }
                      },
                      text: 'Save',
                      options: FFButtonOptions(
                        width: 200,
                        height: 50,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        iconPadding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Funnel Display',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                        elevation: 3,
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
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
