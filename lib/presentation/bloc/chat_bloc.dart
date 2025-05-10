// lib/bloc/chat/chat_bloc.dart
import 'package:ai_assistant/core/enums/ai_model.dart';
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
  AiModel currentModel = AiModel.gemini; // Default model

  ChatBloc() : super(ChatInitial(messages: const [], model: AiModel.gemini)) {
    on<LoadMessagesEvent>((event, emit) async {
      messages = await _chatRepository.getMessages();
      emit(ChatInitial(messages: List.from(messages), model: currentModel));
    });

    on<SendMessageEvent>((event, emit) async {
      // Add user message
      messages.add({"role": "user", "content": event.userMessage});
      await _chatRepository.saveMessage('user', event.userMessage);
      emit(ChatLoading(messages: List.from(messages), model: currentModel));

      try {
        // Send message with current model
        final aiReply = await _chatRepository.sendMessage(event.userMessage, currentModel);

        // Add AI response
        messages.add({"role": "assistant", "content": aiReply});
        await _chatRepository.saveMessage('assistant', aiReply);

        emit(ChatSuccess(messages: List.from(messages), model: currentModel));
      } catch (e) {
        emit(ChatError(
          errorMessage: e.toString(),
          messages: List.from(messages),
          model: currentModel,
        ));
      }
    });

    on<ChangeModelEvent>((event, emit) {
      currentModel = event.newModel;
      emit(ChatInitial(messages: List.from(messages), model: currentModel));
    });
  }
}