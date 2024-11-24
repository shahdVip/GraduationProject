import '/components/order_list/order_list_widget.dart';
import '/custom/util.dart';
import 'order_section_widget.dart' show OrderSectionWidget;
import 'package:flutter/material.dart';

class OrderSectionModel extends FlutterFlowModel<OrderSectionWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for orderList component.
  late OrderListModel orderListModel;

  @override
  void initState(BuildContext context) {
    orderListModel = createModel(context, () => OrderListModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    orderListModel.dispose();
  }
}
