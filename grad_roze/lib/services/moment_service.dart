import 'dart:convert';
import 'package:grad_roze/config.dart';
import 'package:http/http.dart' as http;
import '../../widgets/MomentsModel.dart';

class MomentService {
  // Fetch moments from the backend
  static Future<List<MomentsModel>> fetchMoments() async {
    try {
      final response = await http.get(Uri.parse(fetchMomentsUrl));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => MomentsModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load moments: ${response.reasonPhrase}");
      }
    } catch (error) {
      print('Error fetching moments: $error');
      throw Exception("Failed to fetch moments");
    }
  }
}
