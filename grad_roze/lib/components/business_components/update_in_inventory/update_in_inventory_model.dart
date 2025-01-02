import '/custom/util.dart';
import 'update_in_inventory_widget.dart' show UpdateInInventoryWidget;
import 'package:flutter/material.dart';

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
