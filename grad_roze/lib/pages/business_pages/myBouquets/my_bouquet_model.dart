import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'my_bouquet_widget.dart' show MyBouquetWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
