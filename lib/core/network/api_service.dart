import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  static var _apiKey = dotenv.env['API_KEY'] ?? ''; // <<< Replace here

  Future<String> sendMessage(String userMessage) async {
    final response = await http.post(
      Uri.parse('$_baseUrl?key=$_apiKey'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "contents": [
          {
            "parts": [
              {
                "text": userMessage,
              }
            ]
          }
        ]
      }),
    );

    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception('No candidates found: ${response.body}');
      }
    } else {
      throw Exception('Failed to fetch AI response: ${response.body}');
    }
  }
}
