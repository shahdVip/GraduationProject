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
                    Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Text(
                        'Our Top Picks',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'FunnelDisplay',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: false,
                            color: Color(0xff770404)),
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
              child: GridView(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                scrollDirection: Axis.vertical,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Action for topPicksComponentModel1
                      print('Top Picks Component 1 tapped');
                    },
                    child: wrapWithModel(
                      model: _model.topPicksComponentModel1,
                      updateCallback: () => safeSetState(() {}),
                      child: TopPicksComponentWidget(),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Action for topPicksComponentModel2
                      print('Top Picks Component 2 tapped');
                    },
                    child: wrapWithModel(
                      model: _model.topPicksComponentModel2,
                      updateCallback: () => safeSetState(() {}),
                      child: TopPicksComponentWidget(),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Action for topPicksComponentModel3
                      print('Top Picks Component 3 tapped');
                    },
                    child: wrapWithModel(
                      model: _model.topPicksComponentModel3,
                      updateCallback: () => safeSetState(() {}),
                      child: TopPicksComponentWidget(),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Action for topPicksComponentModel4
                      print('Top Picks Component 4 tapped');
                    },
                    child: wrapWithModel(
                      model: _model.topPicksComponentModel4,
                      updateCallback: () => safeSetState(() {}),
                      child: TopPicksComponentWidget(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
              child: FFButtonWidget(
                onPressed: () {
                  print('Button pressed ...');
                },
                text: 'View More',
                options: FFButtonOptions(
                  height: 40,
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  color: Color(0x00040425),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'FunnelDisplay',
                        color: Color(0xFF040425),
                        fontSize: 10,
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                  elevation: 0,
                  borderSide: BorderSide(
                    color: Color(0xFF040425),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
