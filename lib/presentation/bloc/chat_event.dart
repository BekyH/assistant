part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class SendMessageEvent extends ChatEvent {
  final String userMessage;

  const SendMessageEvent(this.userMessage);

  @override
  List<Object?> get props => [userMessage];
}
