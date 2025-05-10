// lib/bloc/chat/chat_event.dart
part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadMessagesEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String userMessage;

  const SendMessageEvent(this.userMessage);

  @override
  List<Object> get props => [userMessage];
}

class ChangeModelEvent extends ChatEvent {
  final AiModel newModel;

  const ChangeModelEvent(this.newModel);

  @override
  List<Object> get props => [newModel];
}