import '/custom/util.dart';
import '/components/offer_card/offer_card_widget.dart';
import 'offers_widget.dart' show OffersWidget;
import 'package:flutter/material.dart';

class OffersModel extends FlutterFlowModel<OffersWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for offerCard component.
  late OfferCardModel offerCardModel;

  @override
  void initState(BuildContext context) {
    offerCardModel = createModel(context, () => OfferCardModel());
  }

  @override
  void dispose() {
    offerCardModel.dispose();
  }
}
