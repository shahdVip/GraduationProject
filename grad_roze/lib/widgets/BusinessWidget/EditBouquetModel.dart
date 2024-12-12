import '/custom/animations.dart';
import '/custom/count_controller.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'addBouquet.dart' show AddBouquetWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditBouquetModel extends FlutterFlowModel<AddBouquetWidget> {
  /// State fields for stateful widgets in this component.
  final formKey = GlobalKey<FormState>();

  // Controllers for editable fields.
  FocusNode? flowerTypeFocusNode;
  TextEditingController? flowerTypeTextController;
  String? Function(BuildContext, String?)? flowerTypeTextControllerValidator;

  FocusNode? colorFocusNode;
  TextEditingController? colorTextController;
  String? Function(BuildContext, String?)? colorTextControllerValidator;

  FocusNode? descFocusNode;
  TextEditingController? descTextController;
  String? Function(BuildContext, String?)? descTextControllerValidator;

  FocusNode? careTipsFocusNode;
  TextEditingController? careTipsTextController;
  String? Function(BuildContext, String?)? careTipsTextControllerValidator;

  int? quantityValue;

  /// Constructor to accept pre-populated data for editing
  EditBouquetModel({
    String? initialName,
    String? initialDescription,
    String? initialCareTips,
    int? initialPrice,
    List<String>? initialColors,
    List<String>? initialFlowerTypes,
    List<String>? initialTags,
  }) {
    flowerTypeTextController = TextEditingController(text: initialName);
    descTextController = TextEditingController(text: initialDescription);
    careTipsTextController = TextEditingController(text: initialCareTips);
    quantityValue = initialPrice;

    // Optional pre-loading or state management for chips.
    _prepopulateChips(initialColors, initialFlowerTypes, initialTags);
  }

  void _prepopulateChips(
      List<String>? colors, List<String>? flowerTypes, List<String>? tags) {
    // Add logic to pre-populate chips if using a specific state management.
  }

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

    descFocusNode?.dispose();
    descTextController?.dispose();

    careTipsFocusNode?.dispose();
    careTipsTextController?.dispose();
  }

  // Validators
  String? _flowerTypeTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }
    return null;
  }

  String? _colorTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }
    return null;
  }
}
