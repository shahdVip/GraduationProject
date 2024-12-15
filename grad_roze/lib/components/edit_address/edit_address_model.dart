import '/custom/util.dart';
import 'edit_address_widget.dart' show EditAddressWidget;
import 'package:flutter/material.dart';

class EditAddressModel extends FlutterFlowModel<EditAddressWidget> {
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
