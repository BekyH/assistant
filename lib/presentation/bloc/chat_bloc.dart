import 'package:ai_assistant/domain/chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../core/di/locator.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository = locator<ChatRepository>();
  List<Map<String, String>> messages = [];

  ChatBloc() : super(ChatInitial()) {
    on<SendMessageEvent>((event, emit) async {
      // Add user message
      messages.add({"role": "user", "content": event.userMessage});
      emit(ChatLoading(messages: List.from(messages)));

      try {
        // Send message to API (pass only user message as a string)
        final aiReply = await _chatRepository.sendMessage(event.userMessage); // Change here
        
        // Add AI response
        messages.add({"role": "assistant", "content": aiReply});
        emit(ChatSuccess(messages: List.from(messages)));
      } catch (e) {
        emit(ChatError(errorMessage: e.toString(), messages: List.from(messages)));
      }
    });
  }
}
