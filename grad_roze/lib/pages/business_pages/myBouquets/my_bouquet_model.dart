import '/custom/util.dart';
import 'my_bouquet_widget.dart' show MyBouquetWidget;
import 'package:flutter/material.dart';

class MyBouquetModel extends FlutterFlowModel<MyBouquetWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.

  FocusNode? textFieldFocusNode;
  String? Function(String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
  }
}
