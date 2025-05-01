import 'package:ai_assistant/data/repositories/chat_message.dart';
import 'package:ai_assistant/domain/chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/di/locator.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository = locator<ChatRepository>();
  List<Map<String, String>> messages = [];

  ChatBloc() : super(ChatInitial(messages: const [])) {
    on<LoadMessagesEvent>((event, emit) async {
      final Box<ChatMessage> chatBox = Hive.box<ChatMessage>('chatBox');
      messages = chatBox.values
          .map((msg) => {"role": msg.role, "content": msg.content})
          .toList();

      emit(ChatInitial(messages: List.from(messages)));
    });

    on<SendMessageEvent>((event, emit) async {
      final Box<ChatMessage> chatBox = Hive.box<ChatMessage>('chatBox');

      // Add user message
      messages.add({"role": "user", "content": event.userMessage});
      await chatBox.add(ChatMessage(role: 'user', content: event.userMessage));
      emit(ChatLoading(messages: List.from(messages)));

      try {
        // Send only user message
        final aiReply = await _chatRepository.sendMessage(event.userMessage);

        // Add AI response
        messages.add({"role": "assistant", "content": aiReply});
        await chatBox.add(ChatMessage(role: 'assistant', content: aiReply));

        emit(ChatSuccess(messages: List.from(messages)));
      } catch (e) {
        emit(ChatError(errorMessage: e.toString(), messages: List.from(messages)));
      }
    });
  }
}
