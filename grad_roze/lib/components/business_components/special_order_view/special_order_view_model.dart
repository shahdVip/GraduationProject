import '/custom/animations.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'dart:math';
import 'special_order_view_widget.dart' show SpecialOrderViewWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SpecialOrderViewModel extends FlutterFlowModel<SpecialOrderViewWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Price widget.
  FocusNode? priceFocusNode;
  TextEditingController? priceTextController;
  String? Function(BuildContext, String?)? priceTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    priceFocusNode?.dispose();
    priceTextController?.dispose();
  }
}
