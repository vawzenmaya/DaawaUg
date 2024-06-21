// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'chat_provider.dart';

class ChatPage extends StatefulWidget {
  final String userName;

  const ChatPage({super.key, required this.userName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.userName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.report),
            onPressed: () {
              // Report message functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                final messages = chatProvider.getMessages(widget.userName);
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ChatMessageWidget(
                      message: messages[index],
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Send a message .....',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (text) {
                      _sendMessage(text, context);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_controller.text, context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text, BuildContext context) {
    if (text.isEmpty) return;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.sendMessage(widget.userName, text, true);

    _controller.clear();
    _receiveMessage(text, context);
  }

  void _receiveMessage(String userMessage, BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    Future.delayed(const Duration(seconds: 2), () {
      final replyText = 'Reply to: "$userMessage"';
      chatProvider.sendMessage(widget.userName, replyText, false);
    });
  }
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('MMMM d, yyyy HH:mm')
              .format(DateTime.parse(message.dateTime)),
          style: const TextStyle(fontSize: 12.0, color: Colors.grey),
        ),
        Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
            color: message.isUser ? Colors.blue[200] : Colors.grey[300],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            message.text,
            style: TextStyle(
              color: message.isUser ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
