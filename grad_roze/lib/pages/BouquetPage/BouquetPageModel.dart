import '/custom/util.dart';
import 'BouquetPageWidget.dart' show BouquetPageWidget;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/config.dart' show url;

class BouquetPageModel extends FlutterFlowModel<BouquetPageWidget> {
  /// State fields for stateful widgets in this page.
  // State field(s) for RatingBar widget.
  double? ratingBarValue;

  // State field for storing bouquet data.
  Map<String, dynamic>? bouquetData;

  /// Fetch bouquet data from the API by ID.
  Future<void> fetchBouquetData(BuildContext context, String bouquetId) async {
    String apiUrl = '$url/item/items'; // Replace with your actual API base URL
    final myurl = Uri.parse('$apiUrl/$bouquetId');

    try {
      final response = await http.get(myurl);

      if (response.statusCode == 200) {
        bouquetData = json.decode(response.body);
        print(response.body); // Parse JSON response
      } else {
        throw Exception('Failed to load bouquet');
      }
    } catch (error) {
      // Handle API errors gracefully
      print('Error fetching bouquet data: $error');
      bouquetData = null;
    }
  }

  @override
  void initState(BuildContext context) {
    // Initialize state fields if necessary
  }

  @override
  void dispose() {
    // Clean up resources if necessary
  }
}
