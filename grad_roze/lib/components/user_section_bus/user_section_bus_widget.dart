import '/components/edit_user/edit_user_widget.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import 'package:flutter/material.dart';
import 'user_section_bus_model.dart';
export 'user_section_bus_model.dart';
import '/config.dart' show url;

class UserSectionBusWidget extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserSectionBusWidget({required this.userData, super.key});

  @override
  State<UserSectionBusWidget> createState() => _UserSectionBusWidgetState();
}

class _UserSectionBusWidgetState extends State<UserSectionBusWidget> {
  late UserSectionBusModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserSectionBusModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            color: FlutterFlowTheme.of(context).alternate,
            offset: const Offset(
              0.0,
              1.0,
            ),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 44.0,
              height: 44.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  width: 0.5,
                ),
              ),
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: widget.userData['profilePhoto'] == null ||
                          widget.userData['profilePhoto'].isEmpty
                      ? Image.asset(
                          'assets/images/defaults/default_avatar.png',
                          width: 60.0,
                          height: 60.0,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          '$url${widget.userData['profilePhoto']}',
                          width: 60.0,
                          height: 60.0,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Generated code for this Text Widget...
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.pushNamed(
                          'businessProfile',
                          queryParameters: {
                            'username': widget.userData['username'],
                            'email': widget.userData['email'],
                            'address': widget.userData['address'],
                            'phoneNumber': widget.userData['phoneNumber'],
                            'profilePhoto': widget.userData['profilePhoto'],
                          },
                        );
                      },
                      child: Text(
                        widget.userData['username'],
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'Funnel Display',
                              useGoogleFonts: false,
                              color: FlutterFlowTheme.of(context).primary,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 12.0, 0.0),
                      child: Text(
                        widget.userData['email'],
                        style: FlutterFlowTheme.of(context).labelSmall.override(
                              fontFamily: 'Funnel Display',
                              useGoogleFonts: false,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                  ].divide(const SizedBox(height: 4.0)),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0x59040425),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Align(
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          8.0, 4.0, 8.0, 4.0),
                      child: Text(
                        'Business',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Funnel Display',
                              useGoogleFonts: false,
                              color: FlutterFlowTheme.of(context).info,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
              child: FlutterFlowIconButton(
                borderRadius: 8.0,
                buttonSize: 40.0,
                icon: Icon(
                  Icons.edit_outlined,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
                onPressed: () async {
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    enableDrag: false,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: MediaQuery.viewInsetsOf(context),
                        child: EditUserWidget(
                          usernamee: widget.userData['username'],
                          role: 'Business',
                          profilePhoto: widget.userData['profilePhoto'],
                        ),
                      );
                    },
                  ).then((value) => safeSetState(() {}));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
