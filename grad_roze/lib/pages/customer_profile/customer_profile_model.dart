import '/components/user_offer_card/user_offer_card_widget.dart';
import '/custom/util.dart';
import 'customer_profile_widget.dart' show CustomerProfileWidget;
import 'package:flutter/material.dart';

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
