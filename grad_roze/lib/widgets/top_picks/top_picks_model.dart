import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Bouquet/BouquetViewModel.dart';
import '/config.dart' show url;

class TopPicksModel extends ChangeNotifier {
  final String apiUrl = '$url/item/top4-rated-items';

  List<BouquetViewModel> _topPicks = [];
  List<BouquetViewModel> get topPicks => _topPicks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Fetches the top picks from the API and updates the state.
  Future<void> fetchTopPicks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        _topPicks =
            data.map((json) => BouquetViewModel.fromJson(json)).toList();
      } else {
        _errorMessage =
            'Failed to load top picks. Status code: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error fetching top picks: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
