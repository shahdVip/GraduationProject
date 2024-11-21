import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '/custom/util.dart';
import '../pages/homePage/home.dart' show CarouselSliderWidget;

class CarouselSliderModel extends FlutterFlowModel<CarouselSliderWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 1;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
