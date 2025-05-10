// lib/data/services/api_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../core/enums/ai_model.dart';

class ApiService {
  static final _apiKeys = {
    AiModel.gemini: dotenv.env['GEMINI_API_KEY'] ?? '',
    AiModel.chatGPT: dotenv.env['CHATGPT_API_KEY'] ?? '',
    AiModel.deepSeek: dotenv.env['DEEPSEEK_API_KEY'] ?? '',
  };

  static final _baseUrls = {
    AiModel.gemini: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent',
    AiModel.chatGPT: 'https://api.openai.com/v1/chat/completions',
    AiModel.deepSeek: 'https://api.deepseek.com/v1/chat/completions',
  };

  Future<String> sendMessage(String userMessage, AiModel model) async {
    switch (model) {
      case AiModel.gemini:
        return _sendToGemini(userMessage);
      case AiModel.chatGPT:
        return _sendToChatGPT(userMessage);
      case AiModel.deepSeek:
        return _sendToDeepSeek(userMessage);
    }
  }

  Future<String> _sendToGemini(String userMessage) async {
    final response = await http.post(
      Uri.parse('${_baseUrls[AiModel.gemini]}?key=${_apiKeys[AiModel.gemini]}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "contents": [
          {
            "parts": [
              {"text": userMessage}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        return data['candidates'][0]['content']['parts'][0]['text'];
      }
      throw Exception('No candidates found: ${response.body}');
    }
    throw Exception('Failed to fetch AI response: ${response.body}');
  }

  Future<String> _sendToChatGPT(String userMessage) async {
    final response = await http.post(
      Uri.parse(_baseUrls[AiModel.chatGPT]!),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_apiKeys[AiModel.chatGPT]}'
      },
      body: json.encode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": userMessage}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    }
    throw Exception('Failed to fetch AI response: ${response.body}');
  }

  Future<String> _sendToDeepSeek(String userMessage) async {
    final response = await http.post(
      Uri.parse(_baseUrls[AiModel.deepSeek]!),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_apiKeys[AiModel.deepSeek]}'
      },
      body: json.encode({
        "model": "deepseek-chat",
        "messages": [
          {"role": "user", "content": userMessage}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    }
    throw Exception('Failed to fetch AI response: ${response.body}');
  }
}