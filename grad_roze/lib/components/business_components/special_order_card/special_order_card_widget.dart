import 'package:grad_roze/config.dart';

import '/custom/animations.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/components/business_components/special_order_view/special_order_view_widget.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

import 'package:model_viewer_plus/model_viewer_plus.dart';

import 'special_order_card_model.dart';
export 'special_order_card_model.dart';

class SpecialOrderCardWidget extends StatefulWidget {
  final dynamic order; // Pass the order object

  const SpecialOrderCardWidget({super.key, required this.order});

  @override
  State<SpecialOrderCardWidget> createState() => _SpecialOrderCardWidgetState();
}

class _SpecialOrderCardWidgetState extends State<SpecialOrderCardWidget>
    with TickerProviderStateMixin {
  late SpecialOrderCardModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SpecialOrderCardModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 50.0),
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
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
      child: Material(
        color: Colors.transparent,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x520E151B),
                offset: Offset(
                  0.0,
                  2,
                ),
              )
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 200,
                    child: ModelViewer(
                      src:
                          '$url/assets/specialOrders/${widget.order['fileName']}', // Path to your GLB model
                      alt: "A 3D model of an object", // Alternative text
                      ar: false, // Enable AR if needed
                      autoRotate: false, // Automatically rotate the model
                      cameraControls: true, // Enable camera controls
                      backgroundColor: Colors.transparent, // Background color
                      disableZoom: false, // Allow zooming
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.order['orderName']}",
                        style: FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Funnel Display',
                              color: FlutterFlowTheme.of(context).primary,
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                      ),
                      FlutterFlowIconButton(
                        borderRadius: 8,
                        buttonSize: 40,
                        icon: Icon(
                          Icons.visibility_outlined,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 24,
                        ),
                        onPressed: () async {
                          await showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            enableDrag: false,
                            useSafeArea: true,
                            context: context,
                            builder: (context) {
                              return WebViewAware(
                                child: Padding(
                                  padding: MediaQuery.viewInsetsOf(context),
                                  child: SpecialOrderViewWidget(
                                      order: widget.order),
                                ),
                              );
                            },
                          ).then((value) => safeSetState(() {}));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
    );
  }
}
