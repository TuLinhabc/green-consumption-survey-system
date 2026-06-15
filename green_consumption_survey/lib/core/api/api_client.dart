import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ApiClient {
  static Future<List<dynamic>> getQuestions() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/questions/'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Lỗi server: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      rethrow;
    }
  }
}