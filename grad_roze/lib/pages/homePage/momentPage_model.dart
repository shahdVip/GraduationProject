import '/custom/util.dart';

import '/custom/form_field_controller.dart';
import 'momentPage.dart' show MomentPageWidget;
import 'package:flutter/material.dart';

class MomentPageModel extends FlutterFlowModel<MomentPageWidget> {
  ///  State fields for stateful widgets in this page.
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  List<String>? get choiceChipsValues => choiceChipsValueController?.value;
  set choiceChipsValues(List<String>? val) =>
      choiceChipsValueController?.value = val;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
