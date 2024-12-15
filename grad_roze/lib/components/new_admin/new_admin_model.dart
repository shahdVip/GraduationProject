import '/custom/util.dart';
import 'new_admin_widget.dart' show NewAdminWidget;
import 'package:flutter/material.dart';

class NewAdminModel extends FlutterFlowModel<NewAdminWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for username widget.
  FocusNode? usernameFocusNode;
  TextEditingController? usernameTextController;
  String? Function(BuildContext, String?)? usernameTextControllerValidator;
  String? _usernameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Required field!';
    }

    if (!RegExp(kTextValidatorUsernameRegex).hasMatch(val)) {
      return 'Must start with a letter and can only contain letters, digits and - or _.';
    }
    return null;
  }

  // State field(s) for email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  String? _emailTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Required field!';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Invalid email!';
    }
    return null;
  }

  // State field(s) for address widget.
  FocusNode? addressFocusNode;
  TextEditingController? addressTextController;
  String? Function(BuildContext, String?)? addressTextControllerValidator;
  String? _addressTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Required field!';
    }

    return null;
  }

  // State field(s) for phonenumber widget.
  FocusNode? phonenumberFocusNode;
  TextEditingController? phonenumberTextController;
  String? Function(BuildContext, String?)? phonenumberTextControllerValidator;
  String? _phonenumberTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Required field!';
    }

    if (val.length < 10) {
      return 'Requires at least 10 characters.';
    }
    if (val.length > 10) {
      return 'Maximum 10 characters allowed, currently ${val.length}.';
    }
    if (!RegExp('^[0-9]+\$').hasMatch(val)) {
      return 'Invalid text';
    }
    return null;
  }

  // State field(s) for password widget.

  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  String? _passwordTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (!RegExp(
            '^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$%^&*()_+{}\\[\\]:;<>,.?~\\\\/-]).{8,}\$')
        .hasMatch(val)) {
      return 'Weak password!';
    }
    return null;
  }

  @override
  void initState(BuildContext context) {
    usernameTextControllerValidator = _usernameTextControllerValidator;
    emailTextControllerValidator = _emailTextControllerValidator;
    addressTextControllerValidator = _addressTextControllerValidator;
    phonenumberTextControllerValidator = _phonenumberTextControllerValidator;
    passwordTextControllerValidator = _passwordTextControllerValidator;
    passwordVisibility = false;
  }

  @override
  void dispose() {
    usernameFocusNode?.dispose();
    usernameTextController?.dispose();

    emailFocusNode?.dispose();
    emailTextController?.dispose();

    addressFocusNode?.dispose();
    addressTextController?.dispose();

    phonenumberFocusNode?.dispose();
    phonenumberTextController?.dispose();

    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }
}
