// lib/bloc/chat/chat_state.dart
part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  final List<Map<String, String>> messages;
  final AiModel model;
  
  const ChatState({required this.messages, required this.model});

  @override
  List<Object> get props => [messages, model];
}

class ChatInitial extends ChatState {
  const ChatInitial({required super.messages, required super.model});
}

class ChatLoading extends ChatState {
  const ChatLoading({required super.messages, required super.model});
}

class ChatSuccess extends ChatState {
  const ChatSuccess({required super.messages, required super.model});
}

class ChatError extends ChatState {
  final String errorMessage;
  
  const ChatError({
    required this.errorMessage,
    required super.messages,
    required super.model,
  });

  @override
  List<Object> get props => [errorMessage, ...super.props];
}