// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok/api_config.dart';
import 'package:intl/intl.dart';
import 'package:toktok/pages/profile_page/follow_page.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  final String username;
  final String fullNames;
  final String profilePic;
  final String role;

  const ChatPage({
    super.key,
    required this.userId,
    required this.username,
    required this.fullNames,
    required this.profilePic,
    required this.role,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<dynamic> messages = [];
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loggedInUserId = prefs.getString('userID');

    final response = await http.post(
      Uri.parse(ApiConfig.getMessagesUrl),
      body: {
        'userId1': loggedInUserId!,
        'userId2': widget.userId,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        messages = json.decode(response.body);
        isLoading = false;
      });
      _scrollToBottom();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> sendMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loggedInUserId = prefs.getString('userID');
    String message = _messageController.text;

    final response = await http.post(
      Uri.parse(ApiConfig.sendMessageUrl),
      body: {
        'fromUserId': loggedInUserId!,
        'toUserId': widget.userId,
        'message': message,
      },
    );

    if (response.statusCode == 200) {
      _messageController.clear();
      FocusScope.of(context).unfocus();
      fetchMessages();
    } else {}
  }

  Future<void> deleteMessage(String messageId) async {
    final response = await http.post(
      Uri.parse(ApiConfig.deleteMessageUrl),
      body: {
        'messageId': messageId,
      },
    );

    if (response.statusCode == 200) {
      fetchMessages();
    } else {}
  }

  void _showOptionsDialog(BuildContext context, String messageId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.edit, color: Colors.white),
                      Text(
                        'Edit Message',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  onTap: () {
                    // Implement edit message functionality
                  },
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      Text(
                        'Delete Message',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmationDialog(context, messageId);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String messageId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'Confirm Action',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deleteMessage(messageId);
              },
            ),
          ],
        );
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (ApiConfig.emptyProfilePicUrl == widget.profilePic)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowPage(
                        userId: widget.userId,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: const ClipOval(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              )
            else
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowPage(
                        userId: widget.userId,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.grey,
                    image: DecorationImage(
                      image: NetworkImage(widget.profilePic),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 10),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowPage(
                        userId: widget.userId,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      if (widget.fullNames.isNotEmpty)
                        Flexible(
                          child: Text(
                            widget.fullNames,
                            style: const TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      else if (widget.fullNames.isEmpty &&
                          (widget.role == "admin" || widget.role == "channel"))
                        const Text(
                          "No Channel Name",
                          style: TextStyle(color: Colors.red),
                        )
                      else if (widget.fullNames.isEmpty &&
                          widget.role == "user")
                        const Text(
                          "No Profile Name",
                          style: TextStyle(color: Colors.red),
                        ),
                      const SizedBox(width: 3),
                      if (widget.fullNames.isNotEmpty && widget.role == "admin")
                        const Icon(Icons.verified,
                            color: Colors.yellow, size: 15)
                      else if (widget.fullNames.isNotEmpty &&
                          widget.role == "channel")
                        const Icon(Icons.verified,
                            color: Colors.blue, size: 15),
                      const SizedBox(height: 3),
                    ]),
                    Text(
                      "@${widget.username}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ))
        ],
      ),
      body: Column(
        children: [
          if (isLoading)
            Expanded(
              child: Center(
                child: Lottie.asset(
                  'assets/loading.json',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            )
          else if (messages.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  "Type to start a conversation",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var message = messages[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Column(
                      children: [
                        if (message['fromUserId'].toString() == widget.userId)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Card(
                                        color: Colors.blueGrey,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ExpandableText(
                                            message['message'],
                                            style: const TextStyle(
                                                color: Colors.white),
                                            expandText: 'Read more',
                                            collapseText: 'Read less',
                                            expandOnTextTap: true,
                                            collapseOnTextTap: true,
                                            maxLines: 10,
                                            linkColor: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      DateFormat('HH:mm').format(
                                          DateTime.parse(message['datesent'])),
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: GestureDetector(
                                  onLongPress: () {
                                    _showOptionsDialog(context,
                                        message['messageid'].toString());
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Card(
                                        color: Colors.blue,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ExpandableText(
                                            message['message'],
                                            style: const TextStyle(
                                                color: Colors.white),
                                            expandText: 'Read more',
                                            collapseText: 'Read less',
                                            expandOnTextTap: true,
                                            collapseOnTextTap: true,
                                            maxLines: 10,
                                            linkColor: Colors.red,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        DateFormat('HH:mm').format(
                                            DateTime.parse(
                                                message['datesent'])),
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      maxLength: 250,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a message';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      sendMessage();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
