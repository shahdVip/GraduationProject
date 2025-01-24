import '/custom/util.dart';
import 'special_order_view_widget.dart' show SpecialOrderViewWidget;
import 'package:flutter/material.dart';

class SpecialOrderViewModel extends FlutterFlowModel<SpecialOrderViewWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Price widget.
  FocusNode? priceFocusNode;
  TextEditingController? priceTextController;
  String? Function(BuildContext, String?)? priceTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    priceFocusNode?.dispose();
    priceTextController?.dispose();
  }
}
