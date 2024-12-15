import '/components/cart_item/cart_item_widget.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'cart_widget.dart' show CartWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartModel extends FlutterFlowModel<CartWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for cartItem component.
  late CartItemModel cartItemModel;

  @override
  void initState(BuildContext context) {
    cartItemModel = createModel(context, () => CartItemModel());
  }

  @override
  void dispose() {
    cartItemModel.dispose();
  }
}
