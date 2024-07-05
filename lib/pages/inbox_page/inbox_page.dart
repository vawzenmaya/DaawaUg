import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(
          Icons.mail,
          color: Colors.white,
        ),
        leadingWidth: 30,
        title: const Text(
          "Chats",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search for your DaawaTok conversations',
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 25,
                ),
                labelStyle: TextStyle(color: Colors.grey),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 2.5),
                ),
              ),
            ),
          ),
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
                  "Click the + button below to start chating",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          else
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
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          if (ApiConfig.emptyProfilePicUrl ==
                              message.profilePic)
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: const ClipOval(
                                  child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 50,
                              )),
                            )
                          else
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: Colors.grey,
                                image: DecorationImage(
                                  image: NetworkImage(message.profilePic),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (message.fullNames == "" &&
                                  message.role != "user")
                                const Text(
                                  "No Channel Name",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                )
                              else if (message.fullNames == "" &&
                                  message.role == "user")
                                const Text(
                                  "No Profile Name",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                )
                              else
                                Row(
                                  children: [
                                    Text(
                                      message.fullNames,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 3),
                                    if (message.role == 'admin')
                                      const Icon(
                                        Icons.verified,
                                        color: Colors.yellow,
                                        size: 15,
                                      )
                                    else if (message.role == 'channel')
                                      const Icon(
                                        Icons.verified,
                                        color: Colors.blue,
                                        size: 15,
                                      )
                                  ],
                                ),
                              Text(
                                "@${message.username}",
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                              Text(message.message,
                                  style: const TextStyle(color: Colors.white))
                            ],
                          ),
                          const Spacer(),
                          Text(
                            DateFormat('HH:mm')
                                .format(DateTime.parse(message.datesent)),
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                          )
                        ],
                      ),
                    )),
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
        backgroundColor: Colors.greenAccent,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
