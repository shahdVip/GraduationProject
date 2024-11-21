import '/custom/util.dart';
import 'edit_phone_widget.dart' show EditPhoneWidget;
import 'package:flutter/material.dart';

class EditPhoneModel extends FlutterFlowModel<EditPhoneWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for shortBio widget.
  FocusNode? shortBioFocusNode;
  TextEditingController? shortBioTextController;
  String? Function(BuildContext, String?)? shortBioTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    shortBioFocusNode?.dispose();
    shortBioTextController?.dispose();
  }
}
