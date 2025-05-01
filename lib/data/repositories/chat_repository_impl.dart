

import 'package:ai_assistant/core/network/api_service.dart';
import 'package:ai_assistant/domain/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ApiService apiService;

  ChatRepositoryImpl(this.apiService);

  @override
  Future<String> sendMessage(String message) {
    return apiService.sendMessage(message);
  }
}
