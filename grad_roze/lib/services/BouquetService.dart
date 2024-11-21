import 'dart:convert';
import 'package:http/http.dart' as http;
import '/widgets/Bouquet/BouquetModel.dart';

class BouquetService {
  static const String baseUrl = "http://localhost:5000/api/bouquets";

  static Future<List<BouquetModel>> fetchBouquetsForMoment(
      String momentId) async {
    final response = await http.get(Uri.parse('$baseUrl?momentId=$momentId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => BouquetModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch bouquets");
    }
  }
}
