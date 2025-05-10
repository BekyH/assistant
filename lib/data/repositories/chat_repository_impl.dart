// lib/data/repositories/chat_repository_impl.dart

import 'package:ai_assistant/core/network/api_service.dart';
import 'package:ai_assistant/data/repositories/chat_message.dart';
import 'package:ai_assistant/domain/chat_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/enums/ai_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ApiService apiService;
  final Box<ChatMessage> _chatBox = Hive.box<ChatMessage>('chatBox');

  ChatRepositoryImpl(this.apiService);

  @override
  Future<String> sendMessage(String message, AiModel model) async {
    return await apiService.sendMessage(message, model);
  }

  @override
  Future<List<Map<String, String>>> getMessages() async {
    return _chatBox.values
        .map((msg) => {"role": msg.role, "content": msg.content})
        .toList();
  }

  @override
  Future<void> saveMessage(String role, String content) async {
    await _chatBox.add(ChatMessage(role: role, content: content));
  }
}
