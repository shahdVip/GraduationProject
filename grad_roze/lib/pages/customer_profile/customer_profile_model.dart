import '/components/user_offer_card/user_offer_card_widget.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import 'dart:ui';
import 'customer_profile_widget.dart' show CustomerProfileWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomerProfileModel extends FlutterFlowModel<CustomerProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for userOfferCard component.
  late UserOfferCardModel userOfferCardModel;

  @override
  void initState(BuildContext context) {
    userOfferCardModel = createModel(context, () => UserOfferCardModel());
  }

  @override
  void dispose() {
    userOfferCardModel.dispose();
  }
}
