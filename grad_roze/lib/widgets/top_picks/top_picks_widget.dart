import 'package:flutter/material.dart';
import 'package:grad_roze/custom/model.dart';
import 'package:grad_roze/custom/theme.dart';
import 'package:grad_roze/custom/util.dart';
import 'package:grad_roze/custom/widgets.dart';
import 'package:grad_roze/pages/homePage/home.dart';
import 'package:grad_roze/widgets/top_picks_component/top_picks_component_widget.dart';
import 'top_picks_model.dart';
export 'top_picks_model.dart';

class TopPicksWidget extends StatefulWidget {
  const TopPicksWidget({super.key});

  @override
  State<TopPicksWidget> createState() => _TopPicksWidgetState();
}

class _TopPicksWidgetState extends State<TopPicksWidget> {
  late TopPicksModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TopPicksModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
      child: Container(
        width: double.infinity,
        height: 450,
        decoration: BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Generated code for this Text Widget...
                    Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Text(
                        'Our Top Picks',
                        style: FlutterFlowTheme.of(context)
                            .titleMedium
                            .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .titleMediumFamily,
                                color: FlutterFlowTheme.of(context).secondary,
                                letterSpacing: 0.0,
                                useGoogleFonts: false),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 360,
              decoration: BoxDecoration(
                color: Color(0x00FFFFFF),
              ),
            ),
            // Generated code for this Button Widget...
            Flexible(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 24),
                child: FFButtonWidget(
                  onPressed: () {
                    print('Button pressed ...');
                  },
                  text: 'View More',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 60,
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: Color(0x00040425),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).titleSmallFamily,
                          color: FlutterFlowTheme.of(context).secondary,
                          fontSize: 14,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          useGoogleFonts: false,
                        ),
                    elevation: 0,
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).secondary,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
