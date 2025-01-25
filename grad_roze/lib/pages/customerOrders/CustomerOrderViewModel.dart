import 'package:grad_roze/components/customerOrders/BusinessInOrderCardModel.dart';

import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'dart:ui';
import 'CustomerOrderViewWidget.dart' show CustomerOrderViewWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomerOrderViewModel extends FlutterFlowModel<CustomerOrderViewWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for businessInOrderCard component.
  late BusinessInOrderCardModel businessInOrderCardModel;

  @override
  void initState(BuildContext context) {
    businessInOrderCardModel =
        createModel(context, () => BusinessInOrderCardModel());
  }

  @override
  void dispose() {
    businessInOrderCardModel.dispose();
  }
}
