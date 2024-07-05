import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok/api_config.dart';
import 'package:toktok/pages/inbox_page/chat_page.dart';
import 'package:toktok/pages/inbox_page/start_chat.dart';

class MessageData {
  final int userid;
  final String username;
  final String fullNames;
  final String profilePic;
  final String role;
  final String message;
  final String datesent;

  MessageData({
    required this.userid,
    required this.username,
    required this.fullNames,
    required this.profilePic,
    required this.role,
    required this.message,
    required this.datesent,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      userid: json['userid'],
      username: json['username'],
      fullNames: json['fullNames'],
      profilePic: json['profilePic'],
      role: json['role'],
      message: json['message'],
      datesent: json['datesent'],
    );
  }
}

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});
  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  List<MessageData> messages = [];
  List<MessageData> filteredMessages = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMessages();
    searchController.addListener(_filterMessages);
  }

  Future<void> fetchMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId == null) {
      throw Exception('No user ID found in SharedPreferences');
    }

    final response = await http.post(
      Uri.parse(ApiConfig.getConversationsUrl),
      body: {
        'userid': userId,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      setState(() {
        messages =
            responseData.map((data) => MessageData.fromJson(data)).toList();
        filteredMessages = messages;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load messages');
    }
  }

  void _filterMessages() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredMessages = messages.where((message) {
        return message.username.toLowerCase().contains(query) ||
            message.fullNames.toLowerCase().contains(query) ||
            message.message.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_filterMessages);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredMessages.length,
                    itemBuilder: (context, index) {
                      final message = filteredMessages[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(ChatPage(
                              userId: message.userid.toString(),
                              username: message.username,
                              fullNames: message.fullNames,
                              profilePic: message.profilePic,
                              role: message.role));
                        },
                        child: Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(message.profilePic),
                            ),
                            title: Text(message.fullNames),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(message.message),
                                Text(
                                  message.datesent,
                                  style: const TextStyle(fontSize: 12.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const StartChat());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
