import 'package:grad_roze/widgets/top_picks/top_picks_widget.dart';
import 'package:grad_roze/widgets/top_picks_component/top_picks_component_model.dart';

import '/custom/util.dart';
import '../../pages/homePage/home.dart' show TopPicksComponentModel;
import 'package:flutter/material.dart';
import 'top_picks_widget.dart' show TopPicksWidget;

class TopPicksModel extends FlutterFlowModel<TopPicksWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for topPicksComponent component.
  late TopPicksComponentModel topPicksComponentModel1;
  // Model for topPicksComponent component.
  late TopPicksComponentModel topPicksComponentModel2;
  // Model for topPicksComponent component.
  late TopPicksComponentModel topPicksComponentModel3;
  // Model for topPicksComponent component.
  late TopPicksComponentModel topPicksComponentModel4;

  @override
  void initState(BuildContext context) {
    topPicksComponentModel1 =
        createModel(context, () => TopPicksComponentModel());
    topPicksComponentModel2 =
        createModel(context, () => TopPicksComponentModel());
    topPicksComponentModel3 =
        createModel(context, () => TopPicksComponentModel());
    topPicksComponentModel4 =
        createModel(context, () => TopPicksComponentModel());
  }

  @override
  void dispose() {
    topPicksComponentModel1.dispose();
    topPicksComponentModel2.dispose();
    topPicksComponentModel3.dispose();
    topPicksComponentModel4.dispose();
  }
}
