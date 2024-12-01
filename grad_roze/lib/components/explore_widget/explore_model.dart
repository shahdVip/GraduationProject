import '/components/explore_card/explore_card_widget.dart';
import '/custom/util.dart';
import 'explore_widget.dart' show ExploreWidget;

import 'package:flutter/material.dart';

class ExploreModel extends FlutterFlowModel<ExploreWidget> {
  ///  State fields for stateful widgets in this component.
  // Model for topPicksComponent component.
  late ExploreCardModel exploreCardModel;

  @override
  void initState(BuildContext context) {
    exploreCardModel = createModel(context, () => ExploreCardModel());
  }

  @override
  void dispose() {
    exploreCardModel.dispose();
  }
}
