import '/components/cart_item/cart_item_widget.dart';
import '/custom/util.dart';
import 'cart_widget.dart' show CartWidget;
import 'package:flutter/material.dart';

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
