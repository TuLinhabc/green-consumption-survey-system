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


static Future<dynamic> submitResponse({
    required bool buyEcommerce6m,
    required Map<String, int> answers,
    String? gender,
    String? ageGroup,
    String? incomeGroup,
    String? purchaseFrequency,
    String? mainPlatform,
  }) async {
    final List<Map<String, dynamic>> answerList = answers.entries
        .map((e) => {"question_code": e.key, "answer_value": e.value})
        .toList();

    final payload = {
      "buy_ecommerce_6m": buyEcommerce6m,
      "buy_green_product": null,
      "gender": gender,
      "age_group": ageGroup,
      "income_group": incomeGroup,
      "purchase_frequency": purchaseFrequency,
      "main_platform": mainPlatform,
      "answers": answerList,
    };

    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/responses/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception(
        'Submit failed: ${response.statusCode} - ${response.body}',
      );
    }
  }
}