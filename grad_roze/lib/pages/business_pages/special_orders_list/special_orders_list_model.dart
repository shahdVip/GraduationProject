import '/custom/util.dart';
import '/custom/form_field_controller.dart';
import '/components/business_components/special_order_card/special_order_card_widget.dart';
import 'special_orders_list_widget.dart' show SpecialOrdersListWidget;
import 'package:flutter/material.dart';

class SpecialOrdersListModel extends FlutterFlowModel<SpecialOrdersListWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // Model for specialOrderCard component.
  late SpecialOrderCardModel specialOrderCardModel;

  @override
  void initState(BuildContext context) {
    specialOrderCardModel = createModel(context, () => SpecialOrderCardModel());
  }

  @override
  void dispose() {
    specialOrderCardModel.dispose();
  }
}
