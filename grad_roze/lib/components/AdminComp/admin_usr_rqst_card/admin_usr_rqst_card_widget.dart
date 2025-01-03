import 'dart:convert';

import 'package:grad_roze/config.dart';

import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'admin_usr_rqst_card_model.dart';
export 'admin_usr_rqst_card_model.dart';
import 'package:http/http.dart' as http;

class AdminUsrRqstCardWidget extends StatefulWidget {
  final String username;
  final String role;
  final String profilePhoto;
  final String timestamp;
  final Function(String) onRequestProcessed;

  const AdminUsrRqstCardWidget({
    super.key,
    required this.username,
    required this.role,
    required this.profilePhoto,
    required this.timestamp,
    required this.onRequestProcessed,
  });

  @override
  State<AdminUsrRqstCardWidget> createState() => _AdminUsrRqstCardWidgetState();
}

class _AdminUsrRqstCardWidgetState extends State<AdminUsrRqstCardWidget> {
  late AdminUsrRqstCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminUsrRqstCardModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> approveUser(String username) async {
    final url = Uri.parse(approveUserRequestUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username}),
      );

      if (response.statusCode == 200) {
        // Handle success (maybe show a message or update the UI)
        print('User approved successfully');
        widget.onRequestProcessed(
            username); // Call callback to remove the request
      } else {
        // Handle error
        print('Failed to approve user');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> denyUser(String username) async {
    final url = Uri.parse(denyUserRequestUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username}),
      );

      if (response.statusCode == 200) {
        // Handle success
        print('User denied successfully');
        widget.onRequestProcessed(
            username); // Call callback to remove the request
      } else {
        // Handle error
        print('Failed to deny user');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 160.0,
        height: 210.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x34090F13),
              offset: Offset(
                0.0,
                2.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: widget.profilePhoto.isEmpty
                      ? Image.asset(
                          'assets/images/defaults/default_avatar.png', // Path to your default image
                          width: 60.0,
                          height: 60.0,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget
                              .profilePhoto, // Use the passed profile photo URL
                          width: 60.0,
                          height: 60.0,
                          fit: BoxFit.cover,
                        ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                  child: Text(
                    widget.username, // Display the username
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Funnel Display',
                          useGoogleFonts: false,
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                  child: Text(
                    widget.role, // Display the role
                    style: FlutterFlowTheme.of(context).labelSmall.override(
                          fontFamily: 'Funnel Display',
                          useGoogleFonts: false,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 40.0,
                        fillColor: FlutterFlowTheme.of(context).success,
                        icon: FaIcon(
                          FontAwesomeIcons.check,
                          color: FlutterFlowTheme.of(context).info,
                          size: 24.0,
                        ),
                        onPressed: () {
                          approveUser(widget.username);
                        },
                      ),
                      FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 40.0,
                        fillColor: FlutterFlowTheme.of(context).alternate,
                        icon: Icon(
                          Icons.do_not_disturb_rounded,
                          color: FlutterFlowTheme.of(context).info,
                          size: 24.0,
                        ),
                        onPressed: () {
                          denyUser(widget.username);
                        },
                      ),
                    ].divide(const SizedBox(width: 7.0)),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                  child: Text(
                    DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(
                        widget.timestamp)), // Display the timestamp
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Funnel Display',
                          useGoogleFonts: false,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12.0,
                          letterSpacing: 0.0,
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
