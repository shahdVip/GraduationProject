import '/custom/util.dart';
import 'package:flutter/material.dart';
import '/config.dart' show url;
import 'package:http/http.dart' as http;

import 'customerOrdersPageWidget.dart'; // To parse JSON responses

class CustomerOrdersModel extends FlutterFlowModel<CustomerOrdersWidget> {
  ///  State fields for stateful widgets in this page
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
