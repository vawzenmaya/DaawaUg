import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:toktok/pages/inbox_page/chat_provider.dart';
import 'chat_page.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return ListView(
            children: [
              _buildMessageItem(context, chatProvider, 'Kasule'),
              const Divider(color: Colors.grey),
              _buildMessageItem(context, chatProvider, 'Kinataama'),
              const Divider(color: Colors.grey),
              _buildMessageItem(context, chatProvider, 'Lauren'),
              const Divider(color: Colors.grey),
              _buildMessageItem(context, chatProvider, 'Cat'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageItem(
      BuildContext context, ChatProvider chatProvider, String userName) {
    final lastMessage = chatProvider.getLastMessage(userName);
    return MessageItem(
      profileImage: 'assets/${userName.toLowerCase()}.jpg',
      name: userName,
      message: lastMessage?.text ?? 'No messages yet',
      time: lastMessage != null ? _formatDateTime(lastMessage.dateTime) : '',
      onTap: () => _navigateToChat(context, userName),
    );
  }

  void _navigateToChat(BuildContext context, String userName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(userName: userName),
      ),
    );
  }

  String _formatDateTime(String dateTime) {
    DateTime parsedDateTime = DateTime.parse(dateTime);
    DateTime now = DateTime.now();

    if (parsedDateTime.year == now.year &&
        parsedDateTime.month == now.month &&
        parsedDateTime.day == now.day) {
      return DateFormat('h:mm a').format(parsedDateTime);
    } else {
      return DateFormat('M/d/yyyy').format(parsedDateTime);
    }
  }
}

class MessageItem extends StatelessWidget {
  final String profileImage;
  final String name;
  final String message;
  final String time;
  final VoidCallback onTap;

  const MessageItem({
    super.key,
    required this.profileImage,
    required this.name,
    required this.message,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(profileImage),
      ),
      title: Text(name),
      subtitle: Row(
        children: [
          Expanded(child: Text(message, overflow: TextOverflow.ellipsis)),
          Text(time),
        ],
      ),
      onTap: onTap,
    );
  }
}
