import '/components/user_offer_card/user_offer_card_widget.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'customer_profile_model.dart';
export 'customer_profile_model.dart';

class CustomerProfileWidget extends StatefulWidget {
  final String username;
  final String email;
  final String address;
  final String phoneNumber;
  final String profilePhoto;
  const CustomerProfileWidget(
      {super.key,
      required this.username,
      required this.email,
      required this.address,
      required this.phoneNumber,
      required this.profilePhoto});

  @override
  State<CustomerProfileWidget> createState() => _CustomerProfileWidgetState();
}

class _CustomerProfileWidgetState extends State<CustomerProfileWidget> {
  late CustomerProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CustomerProfileModel());

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
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: double.infinity,
                height: 500,
                child: Stack(
                  alignment: const AlignmentDirectional(0, -1),
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(0, -1),
                      child: widget.profilePhoto.isEmpty
                          ? Image.asset(
                              'assets/images/defaults/default_avatar.png', // Path to your default image
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              widget
                                  .profilePhoto, // Use the passed profile photo URL
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0, -1),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(16, 44, 16, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 20,
                                borderWidth: 1,
                                buttonSize: 40,
                                icon: Icon(
                                  Icons.keyboard_arrow_left_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 25,
                                ),
                                onPressed: () async {
                                  context.pop();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0, 1),
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 4,
                            sigmaY: 10,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 144,
                            decoration: const BoxDecoration(
                              color: Color(0x801D2429),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 0, 15, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 8, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          widget.username,
                                          style: FlutterFlowTheme.of(context)
                                              .headlineMedium
                                              .override(
                                                fontFamily: 'Funnel Display',
                                                useGoogleFonts: false,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                fontSize: 26,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 4, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          widget.email,
                                          style: FlutterFlowTheme.of(context)
                                              .labelSmall
                                              .override(
                                                fontFamily: 'Funnel Display',
                                                useGoogleFonts: false,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 4, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          widget.address,
                                          style: FlutterFlowTheme.of(context)
                                              .labelSmall
                                              .override(
                                                fontFamily: 'Funnel Display',
                                                useGoogleFonts: false,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                          child: VerticalDivider(
                                            thickness: 2,
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                          ),
                                        ),
                                        Text(
                                          widget.phoneNumber,
                                          style: FlutterFlowTheme.of(context)
                                              .labelSmall
                                              .override(
                                                fontFamily: 'Funnel Display',
                                                useGoogleFonts: false,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                letterSpacing: 0.0,
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
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Pending Offers',
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            fontFamily: 'Funnel Display',
                            useGoogleFonts: false,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 44),
                child: ListView(
                  padding: EdgeInsets.zero,
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    wrapWithModel(
                      model: _model.userOfferCardModel,
                      updateCallback: () => safeSetState(() {}),
                      child: const UserOfferCardWidget(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
