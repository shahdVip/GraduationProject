import '/custom/util.dart';
import 'addBouquet.dart' show AddBouquetWidget;
import 'package:flutter/material.dart';

class AddBouquetModel extends FlutterFlowModel<AddBouquetWidget> {
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

  // State field(s) for desc widget.
  FocusNode? descFocusNode;
  TextEditingController? descTextController;
  String? Function(BuildContext, String?)? descTextControllerValidator;
  // State field(s) for careTips widget.
  FocusNode? careTipsFocusNode;
  TextEditingController? careTipsTextController;
  String? Function(BuildContext, String?)? careTipsTextControllerValidator;
  // State field(s) for quantity widget.
  int? quantityValue;

  get textFieldFocusNode => null;

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
}
