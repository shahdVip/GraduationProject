import '/custom/theme.dart';
import '/custom/util.dart';
import '/custom/widgets.dart';
import '/components/offer_card/offer_card_widget.dart';
import 'dart:ui';
import 'offers_widget.dart' show OffersWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
