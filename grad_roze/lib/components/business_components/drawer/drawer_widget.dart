import 'package:grad_roze/config.dart';
import 'package:grad_roze/custom/icon_button.dart';
import 'package:hugeicons/hugeicons.dart';

import '/custom/animations.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'drawer_model.dart';
export 'drawer_model.dart';

class SidedrawerWidget extends StatefulWidget {
  const SidedrawerWidget({
    super.key,
  });

  @override
  State<SidedrawerWidget> createState() => _SidedrawerWidgetState();
}

class _SidedrawerWidgetState extends State<SidedrawerWidget>
    with TickerProviderStateMixin {
  late SidedrawerModel _model;
  int navIndex = 0;
  final animationsMap = <String, AnimationInfo>{};

  String businessUsername = '';
  String businessEmail = '';
  String businessprofilePhotoUrl = '';
  bool isLoading = true; // To show loading indicator while fetching

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  Future<void> _fetchUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs
        .getString('jwt_token'); // Retrieve the token from shared preferences
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse(loggedInInfo),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            businessUsername = data['username']; // Set the fetched username
            businessEmail = data['email'];
            businessprofilePhotoUrl = data['profilePhoto'];
            isLoading = false; // Stop loading
          });
        } else {
          setState(() {
            isLoading = false; // Stop loading even if error occurs
          });
          // Handle error if needed
          print('Failed to load profile');
        }
      } catch (e) {
        setState(() {
          isLoading = false; // Stop loading in case of error
        });
        print('Error: $e');
      }
    } else {
      print('No token found');
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SidedrawerModel());
    _fetchUserProfile(); // Fetch user profile when the page loads

    animationsMap.addAll({
      'containerOnActionTriggerAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, -7.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, -7.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, -7.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, -7.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation4': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, -7.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation5': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, -7.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation6': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, -7.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation7': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, -7.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnActionTriggerAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(-40.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

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
      width: 270,
      height: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondary,
        boxShadow: [
          BoxShadow(
            blurRadius: 0,
            color: FlutterFlowTheme.of(context).alternate,
            offset: Offset(
              1,
              0,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(0),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).error,
                  boxShadow: [
                    BoxShadow(
                      color: FlutterFlowTheme.of(context).error,
                      offset: Offset(
                        0,
                        1,
                      ),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 24, 16, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                            child: Text(
                              'Roze`',
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    fontFamily: 'Funnel Display',
                                    color: FlutterFlowTheme.of(context).info,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).info,
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: businessprofilePhotoUrl.isNotEmpty
                                    ? Image.network(
                                        businessprofilePhotoUrl, // Use the URL from the database
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/defaults/default_avatar.png', // Default avatar
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    businessUsername.isEmpty
                                        ? 'Loading...'
                                        : businessUsername,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily: 'Funnel Display',
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 4, 0, 0),
                                    child: Text(
                                      businessEmail.isEmpty
                                          ? 'Loading...'
                                          : businessEmail,
                                      style: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .override(
                                            fontFamily: 'Funnel Display',
                                            color: FlutterFlowTheme.of(context)
                                                .accent4,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Icon(
                            Icons.notifications_none,
                            color: FlutterFlowTheme.of(context).info,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  setState(() {
                    navIndex = 0;
                  });
                  if (animationsMap['containerOnActionTriggerAnimation1'] !=
                      null) {
                    await animationsMap['containerOnActionTriggerAnimation1']!
                        .controller
                        .forward(from: 0.0);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(0, 12, 12, 12),
                          child: Visibility(
                            visible: navIndex == 0,
                            child: Container(
                              width: 4,
                              height: 100,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).info,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ).animateOnActionTrigger(
                              animationsMap[
                                  'containerOnActionTriggerAnimation1']!,
                            ),
                          ),
                        ),
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedFlowerPot,
                          color: Colors.white,
                          size: 28.0,
                        ),
                        // Icon(
                        //   Icons.stacked_bar_chart_rounded,
                        //   color: FlutterFlowTheme.of(context).info,
                        //   size: 28,
                        // ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Text(
                            'Inventory',
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Funnel Display',
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  setState(() {
                    navIndex = 1;
                  });
                  if (animationsMap['containerOnActionTriggerAnimation1'] !=
                      null) {
                    await animationsMap['containerOnActionTriggerAnimation1']!
                        .controller
                        .forward(from: 0.0);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(0, 12, 12, 12),
                          child: Visibility(
                            visible: navIndex == 1,
                            child: Container(
                              width: 4,
                              height: 100,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).info,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ).animateOnActionTrigger(
                              animationsMap[
                                  'containerOnActionTriggerAnimation1']!,
                            ),
                          ),
                        ),
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedDeliverySent01,
                          color: Colors.white,
                          size: 28.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Text(
                            'Restock',
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Funnel Display',
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  setState(() {
                    navIndex = 2;
                  });
                  if (animationsMap['containerOnActionTriggerAnimation1'] !=
                      null) {
                    await animationsMap['containerOnActionTriggerAnimation1']!
                        .controller
                        .forward(from: 0.0);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(0, 12, 12, 12),
                          child: Visibility(
                            visible: navIndex == 2,
                            child: Container(
                              width: 4,
                              height: 100,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).info,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ).animateOnActionTrigger(
                              animationsMap[
                                  'containerOnActionTriggerAnimation1']!,
                            ),
                          ),
                        ),
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedCalendar03,
                          color: Colors.white,
                          size: 28.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Text(
                            'Calendar',
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Funnel Display',
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  setState(() {
                    navIndex = 3;
                  });
                  if (animationsMap['containerOnActionTriggerAnimation1'] !=
                      null) {
                    await animationsMap['containerOnActionTriggerAnimation1']!
                        .controller
                        .forward(from: 0.0);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(0, 12, 12, 12),
                          child: Visibility(
                            visible: navIndex == 3,
                            child: Container(
                              width: 4,
                              height: 100,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).info,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ).animateOnActionTrigger(
                              animationsMap[
                                  'containerOnActionTriggerAnimation1']!,
                            ),
                          ),
                        ),
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedTask01,
                          color: Colors.white,
                          size: 28.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Text(
                            'Requests',
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Funnel Display',
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  setState(() {
                    navIndex = 4;
                  });
                  if (animationsMap['containerOnActionTriggerAnimation1'] !=
                      null) {
                    await animationsMap['containerOnActionTriggerAnimation1']!
                        .controller
                        .forward(from: 0.0);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(0, 12, 12, 12),
                          child: Visibility(
                            visible: navIndex == 4,
                            child: Container(
                              width: 4,
                              height: 100,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).info,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ).animateOnActionTrigger(
                              animationsMap[
                                  'containerOnActionTriggerAnimation1']!,
                            ),
                          ),
                        ),
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedAutoConversations,
                          color: Colors.white,
                          size: 28.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Text(
                            'Statics',
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Funnel Display',
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  setState(() {
                    navIndex = 5;
                  });
                  if (animationsMap['containerOnActionTriggerAnimation1'] !=
                      null) {
                    await animationsMap['containerOnActionTriggerAnimation1']!
                        .controller
                        .forward(from: 0.0);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(0, 12, 12, 12),
                          child: Visibility(
                            visible: navIndex == 5,
                            child: Container(
                              width: 4,
                              height: 100,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).info,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ).animateOnActionTrigger(
                              animationsMap[
                                  'containerOnActionTriggerAnimation1']!,
                            ),
                          ),
                        ),
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedIdea01,
                          color: Colors.white,
                          size: 28.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Text(
                            'Design',
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Funnel Display',
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  setState(() {
                    navIndex = 6;
                  });
                  if (animationsMap['containerOnActionTriggerAnimation1'] !=
                      null) {
                    await animationsMap['containerOnActionTriggerAnimation1']!
                        .controller
                        .forward(from: 0.0);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(0, 12, 12, 12),
                          child: Visibility(
                            visible: navIndex == 6,
                            child: Container(
                              width: 4,
                              height: 100,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).info,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ).animateOnActionTrigger(
                              animationsMap[
                                  'containerOnActionTriggerAnimation1']!,
                            ),
                          ),
                        ),
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedFlower,
                          color: Colors.white,
                          size: 28.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Text(
                            'Bouqets',
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Funnel Display',
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  setState(() {
                    navIndex = 7;
                  });
                  if (animationsMap['containerOnActionTriggerAnimation1'] !=
                      null) {
                    await animationsMap['containerOnActionTriggerAnimation1']!
                        .controller
                        .forward(from: 0.0);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(0, 12, 12, 12),
                          child: Visibility(
                            visible: navIndex == 7,
                            child: Container(
                              width: 4,
                              height: 100,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).info,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ).animateOnActionTrigger(
                              animationsMap[
                                  'containerOnActionTriggerAnimation1']!,
                            ),
                          ),
                        ),
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedComment01,
                          color: Colors.white,
                          size: 28.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Text(
                            'Chats',
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Funnel Display',
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Generated code for this Column Widget...
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      height: 12,
                      thickness: 2,
                      color: FlutterFlowTheme.of(context).accent1,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              if ((Theme.of(context).brightness ==
                                      Brightness.light) ==
                                  true) {
                                setDarkModeSetting(context, ThemeMode.dark);
                                if (animationsMap[
                                        'containerOnActionTriggerAnimation2'] !=
                                    null) {
                                  await animationsMap[
                                          'containerOnActionTriggerAnimation2']!
                                      .controller
                                      .forward(from: 0.0);
                                }
                              } else {
                                setDarkModeSetting(context, ThemeMode.light);
                                if (animationsMap[
                                        'containerOnActionTriggerAnimation2'] !=
                                    null) {
                                  await animationsMap[
                                          'containerOnActionTriggerAnimation2']!
                                      .controller
                                      .forward(from: 0.0);
                                }
                              }
                            },
                            child: Container(
                              width: 80,
                              height: 40,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).accent1,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).accent1,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(2),
                                child: Stack(
                                  alignment: AlignmentDirectional(0, 0),
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(-0.9, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            6, 0, 0, 0),
                                        child: Icon(
                                          Icons.wb_sunny_rounded,
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(1, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 6, 0),
                                        child: Icon(
                                          Icons.mode_night_rounded,
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(1, 0),
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color: Color(0x430B0D0F),
                                              offset: Offset(
                                                0.0,
                                                2,
                                              ),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          shape: BoxShape.rectangle,
                                        ),
                                      ).animateOnActionTrigger(
                                        animationsMap[
                                            'containerOnActionTriggerAnimation2']!,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        FlutterFlowIconButton(
                          borderRadius: 8,
                          buttonSize: 40,
                          icon: Icon(
                            Icons.logout_rounded,
                            color: FlutterFlowTheme.of(context).info,
                            size: 30,
                          ),
                          onPressed: () async {
                            // Perform the logout logic
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.remove(
                                'jwt_token'); // Remove token to log the user out

                            // Navigate to the login page after logout
                            context.pushNamed('onboarding');
                          },
                        ),
                      ],
                    ),
                  ].divide(SizedBox(height: 12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
