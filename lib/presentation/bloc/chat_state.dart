part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  final List<Map<String, String>> messages;
  const ChatState({this.messages = const []});
}

class ChatInitial extends ChatState {
  const ChatInitial({List<Map<String, String>> messages = const []}) : super(messages: messages);

  @override
  List<Object?> get props => [messages];
}

class ChatLoading extends ChatState {
  const ChatLoading({required List<Map<String, String>> messages}) : super(messages: messages);

  @override
  List<Object?> get props => [messages];
}

class ChatSuccess extends ChatState {
  const ChatSuccess({required List<Map<String, String>> messages}) : super(messages: messages);

  @override
  List<Object?> get props => [messages];
}

class ChatError extends ChatState {
  final String errorMessage;
  const ChatError({required this.errorMessage, required List<Map<String, String>> messages})
      : super(messages: messages);

  @override
  List<Object?> get props => [errorMessage, messages];
}
