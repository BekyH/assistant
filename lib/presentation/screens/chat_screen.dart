// lib/presentation/screens/chat_screen.dart
import 'package:ai_assistant/core/enums/ai_model.dart';
import 'package:ai_assistant/presentation/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessagesEvent());
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatBloc>().add(SendMessageEvent(text));
      _controller.clear();
    }
  }

  void _changeModel(AiModel newModel) {
    context.read<ChatBloc>().add(ChangeModelEvent(newModel));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          // BlocBuilder<ChatBloc, ChatState>(
          //   builder: (context, state) {
          //     return PopupMenuButton<AiModel>(
          //       icon: const Icon(Icons.model_training),
          //       onSelected: _changeModel,
          //       itemBuilder: (context) => AiModel.values.map((model) {
          //         return PopupMenuItem<AiModel>(
          //           value: model,
          //           child: Row(
          //             children: [
          //               Icon(
          //                 Icons.check,
          //                 color: state.model == model 
          //                     ? Colors.blue 
          //                     : Colors.transparent,
          //               ),
          //               const SizedBox(width: 8),
          //               Text(model.displayName),
          //             ],
          //           ),
          //         );
          //       }).toList(),
          //     );
          //   },
          // ),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'Current model: ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Chip(
                      label: Text(state.model.displayName),
                      backgroundColor: Colors.blue.withOpacity(0.1),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  });
                }

                final messages = state.messages;
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final reversedIndex = messages.length - 1 - index;
                    return MessageBubble(message: messages[reversedIndex]);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Ask something...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  IconButton(
                    onPressed: _send,
                    icon: const Icon(Icons.send_rounded),
                    color: Colors.deepOrange,
                    splashRadius: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}