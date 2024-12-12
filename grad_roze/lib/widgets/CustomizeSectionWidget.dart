import '/custom/animations.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'CustomizeSectionModel.dart';
export 'CustomizeSectionModel.dart';

class CustomizeSectionWidget extends StatefulWidget {
  const CustomizeSectionWidget({super.key});

  @override
  State<CustomizeSectionWidget> createState() => _CustomizeSectionWidgetState();
}

class _CustomizeSectionWidgetState extends State<CustomizeSectionWidget>
    with TickerProviderStateMixin {
  late CustomizeSectionModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CustomizeSectionModel());

    animationsMap.addAll({
      'buttonOnPageLoadAnimation': AnimationInfo(
        loop: false,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 5000.0.ms,
            duration: 1500.0.ms,
            color: const Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
    });
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
      height: 280,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).primary,
            FlutterFlowTheme.of(context).secondary
          ],
          stops: const [0, 1],
          begin: const AlignmentDirectional(0, -1),
          end: const AlignmentDirectional(0, 1),
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://images.unsplash.com/photo-1487530811176-3780de880c2d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxjdXN0b20lMjBib3VxdWV0JTIwfGVufDB8fHx8MTczMjQ1OTY2Nnww&ixlib=rb-4.0.3&q=80&w=1080',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  FlutterFlowTheme.of(context).accent4,
                  const Color(0x00FFFFFF),
                  FlutterFlowTheme.of(context).secondaryBackground
                ],
                stops: const [0, 0.7, 1],
                begin: const AlignmentDirectional(0, -1),
                end: const AlignmentDirectional(0, 1),
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0, 1),
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0x00FFFFFF),
                    FlutterFlowTheme.of(context).accent4,
                    FlutterFlowTheme.of(context).secondaryBackground
                  ],
                  stops: const [0, 0.3, 1],
                  begin: const AlignmentDirectional(0, -1),
                  end: const AlignmentDirectional(0, 1),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 3),
                      child: Text(
                        'Make Your OWN Bouquet',
                        style:
                            FlutterFlowTheme.of(context).headlineLarge.override(
                                  fontFamily: 'Funnel Display',
                                  letterSpacing: 0.0,
                                  useGoogleFonts: false,
                                ),
                      )),
                  FFButtonWidget(
                    onPressed: () {
                      print('Button pressed ...');
                    },
                    text: 'Customize a Bouquet',
                    options: FFButtonOptions(
                      height: 40,
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      iconPadding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Funnel Display',
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ).animateOnPageLoad(
                      animationsMap['buttonOnPageLoadAnimation']!),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  FlutterFlowTheme.of(context).secondaryBackground,
                  FlutterFlowTheme.of(context).accent4,
                  const Color(0x00FFFFFF)
                ],
                stops: const [0, 0.3, 0.5],
                begin: const AlignmentDirectional(0, -1),
                end: const AlignmentDirectional(0, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
