import '/custom/util.dart';
import 'edit_password_widget.dart' show EditPasswordWidget;
import 'package:flutter/material.dart';

class EditPasswordModel extends FlutterFlowModel<EditPasswordWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for shortBio widget.
  FocusNode? shortBioFocusNode;
  TextEditingController? shortBioTextController;
  late bool shortBioVisibility;
  String? Function(BuildContext, String?)? shortBioTextControllerValidator;
  String? _shortBioTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Required field!';
    }

    if (!RegExp(
            '^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$%^&*()_+{}\\[\\]:;<>,.?~\\\\/-]).{8,}\$')
        .hasMatch(val)) {
      return 'Weak Password!';
    }
    return null;
  }

  @override
  void initState(BuildContext context) {
    shortBioVisibility = false;
    shortBioTextControllerValidator = _shortBioTextControllerValidator;
  }

  @override
  void dispose() {
    shortBioFocusNode?.dispose();
    shortBioTextController?.dispose();
  }
}
