import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grad_roze/components/business_components/inventory_comp/flower_in_inventory_card/flower_in_inventory_card_model.dart';
import 'package:provider/provider.dart';

import '/components/business_components/drawer/drawer_widget.dart';

import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'inventory_widget.dart' show InventoryWidget;

class InventoryModel extends FlutterFlowModel<InventoryWidget> {
  ///  State fields for stateful widgets in this page.
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for flowerInInventoryCard component.
  late FlowerInInventoryCardModel flowerInInventoryCardModel;
  // Model for sidedrawer component.
  late SidedrawerModel sidedrawerModel;

  @override
  void initState(BuildContext context) {
    flowerInInventoryCardModel =
        createModel(context, () => FlowerInInventoryCardModel());
    sidedrawerModel = createModel(context, () => SidedrawerModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    flowerInInventoryCardModel.dispose();
    sidedrawerModel.dispose();
  }
}
