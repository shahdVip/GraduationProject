import '/components/explore_card/explore_card_widget.dart';
import '/custom/animations.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'dart:math';
import 'explore_widget.dart' show ExploreWidget;

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
