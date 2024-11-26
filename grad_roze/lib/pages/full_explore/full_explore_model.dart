import 'package:grad_roze/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/components/explore_card/explore_card_widget.dart';
import '/custom/choice_chips.dart';
import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '/custom/widgets.dart';
import '/custom/form_field_controller.dart';
import 'full_explore_widget.dart' show ViewMoreExploreWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ViewMoreExploreModel extends FlutterFlowModel<ViewMoreExploreWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  List<String>? get choiceChipsValues => choiceChipsValueController?.value;
  set choiceChipsValues(List<String>? val) =>
      choiceChipsValueController?.value = val;
  // Model for ExploreCard component.
  late ExploreCardModel exploreCardModel;

  @override
  void initState(BuildContext context) {
    exploreCardModel = createModel(context, () => ExploreCardModel());
  }

  Future<List<String>> fetchFlowerTypes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username'); // Get username

    final response = await http.get(Uri.parse('$fetchflowerTypes/$username'));

    if (response.statusCode == 200) {
      // Parse the JSON response and return the flowerType array
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load flower types');
    }
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    exploreCardModel.dispose();
  }
}
