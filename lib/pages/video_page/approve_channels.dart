import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:toktok/api_config.dart';

class ApproveChannels extends StatefulWidget {
  const ApproveChannels({super.key});

  @override
  State<ApproveChannels> createState() => _ApproveChannelsState();
}

class _ApproveChannelsState extends State<ApproveChannels> {
  List<dynamic> users = [];
  List<dynamic> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  Set<String> approvedUsernames = {};

  @override
  void initState() {
    super.initState();
    fetchUsers();
    searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterUsers);
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchUsers() async {
    final response =
        await http.get(Uri.parse(ApiConfig.fetchUsersForApprovelUrl));

    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
        filteredUsers = users;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  void _filterUsers() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredUsers = users.where((user) {
        return user['username'].toLowerCase().contains(query) ||
            user['email'].toLowerCase().contains(query) ||
            user['phoneNumber'].toLowerCase().contains(query) ||
            user['fullNames'].toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _approveUser(String username) async {
    final response = await http.post(
      Uri.parse(ApiConfig.approveUserUrl),
      body: {
        'username': username,
        'role': 'channel',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        approvedUsernames.add(username);
      });
    } else {
      throw Exception('Failed to update user role');
    }
  }

  bool isUserApproved(String username) {
    return approvedUsernames.contains(username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text(
          "Approve New Channels",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
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
          ),
          Expanded(
            child: filteredUsers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/loading.json',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        const Text(
                          "No users found",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final username = filteredUsers[index]['username'];
                      final isApproved = isUserApproved(username);

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  if (ApiConfig.emptyProfilePicUrl ==
                                      filteredUsers[index]['profilePic'])
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
                                          image: NetworkImage(
                                              filteredUsers[index]
                                                  ['profilePic']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (filteredUsers[index]['fullNames'] ==
                                          "")
                                        const Text(
                                          "No Profile Name",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )
                                      else
                                        Text(
                                          filteredUsers[index]['fullNames'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      Text(
                                        "@$username",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await _approveUser(username);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              isApproved
                                                  ? Icons.verified_user
                                                  : Icons.approval_rounded,
                                              size: 18,
                                              color: isApproved
                                                  ? Colors.greenAccent
                                                  : Colors.yellow,
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              isApproved
                                                  ? "Approved"
                                                  : "Approve",
                                              style: TextStyle(
                                                color: isApproved
                                                    ? Colors.greenAccent
                                                    : Colors.yellow,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              if (filteredUsers[index]['email'] != "")
                                Row(
                                  children: [
                                    const SizedBox(width: 60),
                                    const Icon(
                                      Icons.email,
                                      size: 18,
                                      color: Colors.greenAccent,
                                    ),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        filteredUsers[index]['email'],
                                        style: const TextStyle(
                                            color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Row(
                                  children: [
                                    const SizedBox(width: 60),
                                    const Icon(
                                      Icons.phone,
                                      size: 18,
                                      color: Colors.greenAccent,
                                    ),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        filteredUsers[index]['phoneNumber'],
                                        style: const TextStyle(
                                            color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
