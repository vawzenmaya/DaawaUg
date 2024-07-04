import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok/api_config.dart';
import 'package:toktok/pages/inbox_page/chat_page.dart';
import 'package:toktok/pages/inbox_page/start_chat.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});
  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  List<dynamic> messages = [];
  List<dynamic> users = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  List<dynamic> filteredMessages = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    searchController.addListener(_filterMessages);
  }

  Future<void> fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userID') ?? '';

      final response = await http.post(
        Uri.parse(ApiConfig.getConversationsUrl),
        body: {'userId': userId},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          messages = data['messages'];
          users = data['users'];
          filteredMessages = messages;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar(
        'Network Error',
        'Check your internet connection',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void _filterMessages() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredMessages = messages.where((message) {
        var user = users.firstWhere(
          (user) =>
              user['userid'] == message['fromUserId'] ||
              user['userid'] == message['toUserId'],
          orElse: () => null,
        );
        return user != null &&
            (user['fullNames'].toLowerCase().contains(query));
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_filterMessages);
    searchController.dispose();
    super.dispose();
  }

  Widget _buildMessageTile(dynamic message) {
    var user = users.firstWhere(
      (user) =>
          user['userid'] == message['fromUserId'] ||
          user['userid'] == message['toUserId'],
      orElse: () => null,
    );

    if (user == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              userId: user['userid'],
              username: user['username'],
              fullNames: user['fullNames'],
              profilePic: user['profilePic'],
              role: user['role'],
            ),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  if (ApiConfig.emptyProfilePicUrl == user['profilePic'])
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
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: Colors.grey,
                        image: DecorationImage(
                          image: NetworkImage(user['profilePic']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (user['fullNames'] == "" && user['role'] != "user")
                        const Text(
                          "No Channel Name",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )
                      else if (user['fullNames'] == "" &&
                          user['role'] == "user")
                        const Text(
                          "No Profile Name",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )
                      else
                        Row(
                          children: [
                            Text(
                              user['fullNames'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 3),
                            if (user['role'] == 'admin')
                              const Icon(
                                Icons.verified,
                                color: Colors.yellow,
                                size: 15,
                              )
                            else if (user['role'] == 'channel')
                              const Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 15,
                              ),
                          ],
                        ),
                      Text(
                        message['message'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    message['datesent'],
                    style: const TextStyle(
                        color: Colors.greenAccent, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.chat,
          color: Colors.white,
        ),
        title: const Text(
          "DaawaChat",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
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
            Expanded(
              child: isLoading
                  ? Center(
                      child: Lottie.asset(
                        'assets/loading.json',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    )
                  : filteredMessages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'assets/no_data.json',
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                              const Text(
                                "No DaawaChat messages found",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredMessages.length,
                          itemBuilder: (context, index) {
                            return _buildMessageTile(filteredMessages[index]);
                          },
                        ),
            ),
          ],
        ),
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
