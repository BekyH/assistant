part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class LoadMessagesEvent extends ChatEvent {
  const LoadMessagesEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String userMessage;

  const SendMessageEvent(this.userMessage);

  @override
  List<Object?> get props => [userMessage];
}

class ClearChatEvent extends ChatEvent {
  const ClearChatEvent();

  @override
  List<Object?> get props => [];
}
