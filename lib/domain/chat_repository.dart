import 'package:ai_assistant/core/enums/ai_model.dart';

abstract class ChatRepository {
  Future<String> sendMessage(String message,AiModel model);
    Future<List<Map<String, String>>> getMessages();
  Future<void> saveMessage(String role, String content);
}
