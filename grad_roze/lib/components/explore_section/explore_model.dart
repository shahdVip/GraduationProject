import '/widgets/top_picks_component/top_picks_component_widget.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'explore_widget.dart' show ExploreWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ExploreModel extends FlutterFlowModel<ExploreWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for topPicksComponent component.
  late TopPicksComponentModel topPicksComponentModel;

  @override
  void initState(BuildContext context) {
    topPicksComponentModel =
        createModel(context, () => TopPicksComponentModel());
  }

  @override
  void dispose() {
    topPicksComponentModel.dispose();
  }
}
