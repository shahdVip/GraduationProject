import '/components/user_section_bus/user_section_bus_widget.dart';
import '/components/user_section_cus/user_section_cus_widget.dart';
import '/components/user_section_pending/user_section_pending_widget.dart';
import '/custom/util.dart';
import '/custom/form_field_controller.dart';
import 'admin_users_section_widget.dart' show AdminUsersSectionWidget;
import 'package:flutter/material.dart';

class AdminUsersSectionModel extends FlutterFlowModel<AdminUsersSectionWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // Model for UserSectionCus component.
  late UserSectionCusModel userSectionCusModel;
  // Model for UserSectionBus component.
  late UserSectionBusModel userSectionBusModel;
  // Model for UserSectionPending component.
  late UserSectionPendingModel userSectionPendingModel;

  @override
  void initState(BuildContext context) {
    userSectionCusModel = createModel(context, () => UserSectionCusModel());
    userSectionBusModel = createModel(context, () => UserSectionBusModel());
    userSectionPendingModel =
        createModel(context, () => UserSectionPendingModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    userSectionCusModel.dispose();
    userSectionBusModel.dispose();
    userSectionPendingModel.dispose();
  }
}
