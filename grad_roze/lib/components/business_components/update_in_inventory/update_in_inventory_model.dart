import '/custom/animations.dart';
import '/custom/count_controller.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'update_in_inventory_widget.dart' show UpdateInInventoryWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UpdateInInventoryModel extends FlutterFlowModel<UpdateInInventoryWidget> {
  ///  State fields for stateful widgets in this component.
  final formKey = GlobalKey<FormState>();
  // State field(s) for flowerType widget.
  FocusNode? flowerTypeFocusNode;
  TextEditingController? flowerTypeTextController;
  String? Function(BuildContext, String?)? flowerTypeTextControllerValidator;
  String? _flowerTypeTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for color widget.
  FocusNode? colorFocusNode;
  TextEditingController? colorTextController;
  String? Function(BuildContext, String?)? colorTextControllerValidator;
  String? _colorTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for caretips widget.
  FocusNode? caretipsFocusNode;
  TextEditingController? caretipsTextController;
  String? Function(BuildContext, String?)? caretipsTextControllerValidator;
  // State field(s) for quantity widget.
  int? quantityValue;

  @override
  void initState(BuildContext context) {
    flowerTypeTextControllerValidator = _flowerTypeTextControllerValidator;
    colorTextControllerValidator = _colorTextControllerValidator;
  }

  @override
  void dispose() {
    flowerTypeFocusNode?.dispose();
    flowerTypeTextController?.dispose();

    colorFocusNode?.dispose();
    colorTextController?.dispose();

    caretipsFocusNode?.dispose();
    caretipsTextController?.dispose();
  }
}
