import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'favorite_list_model.dart';
export 'favorite_list_model.dart';

class FavoriteListWidget extends StatefulWidget {
  const FavoriteListWidget({super.key});

  @override
  State<FavoriteListWidget> createState() => _FavoriteListWidgetState();
}

class _FavoriteListWidgetState extends State<FavoriteListWidget> {
  late FavoriteListModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FavoriteListModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Icons.keyboard_arrow_left_rounded,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 30,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'My Favorites',
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Divider(
                  thickness: 2,
                  color: FlutterFlowTheme.of(context).alternate,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
                        child: Container(
                          width: 100,
                          height: 72,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 0,
                                color: FlutterFlowTheme.of(context).alternate,
                                offset: const Offset(
                                  0,
                                  1,
                                ),
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 0, 16, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      width: 2,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(44),
                                      child: Image.asset(
                                        'assets/images/buslogoo.jpg',
                                        width: 44,
                                        height: 44,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 0, 4),
                                          child: Text(
                                            'business name',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  fontFamily: 'Funnel Display',
                                                  useGoogleFonts: false,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                        Text(
                                          'business@gmail.com',
                                          style: FlutterFlowTheme.of(context)
                                              .labelMedium
                                              .override(
                                                fontFamily: 'Funnel Display',
                                                useGoogleFonts: false,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed('businessProfile');
                                  },
                                  child: Icon(
                                    Icons.chevron_right_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 24,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
