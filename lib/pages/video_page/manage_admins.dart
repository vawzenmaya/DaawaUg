import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok/api_config.dart';

class ManageApprovedAdmins extends StatefulWidget {
  const ManageApprovedAdmins({super.key});

  @override
  State<ManageApprovedAdmins> createState() => _ManageApprovedAdminsState();
}

class _ManageApprovedAdminsState extends State<ManageApprovedAdmins> {
  List<dynamic> users = [];
  List<dynamic> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  Set<String> unapprovedUsernames = {};
  Set<String> adminUsernames = {};

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId == null) {
      throw Exception('No user ID found in SharedPreferences');
    }

    final response = await http.post(
      Uri.parse(ApiConfig.fetchApprovedAdminsUrl),
      body: {'userid': userId},
    );

    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
        filteredUsers = users;
      });
    } else {
      throw Exception('Failed to load admins');
    }
  }

  void _filterUsers() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredUsers = users.where((user) {
        return user['username'].toLowerCase().contains(query) ||
            user['fullNames'].toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _approveUser(String username) async {
    final response = await http.post(
      Uri.parse(ApiConfig.unapproveUserUrl),
      body: {
        'username': username,
        'role': 'user',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        unapprovedUsernames.add(username);
        adminUsernames.remove(username);
      });
    } else {
      throw Exception('Failed to update user role');
    }
  }

  Future<void> _approveAdmin(String username) async {
    final response = await http.post(
      Uri.parse(ApiConfig.approveAdminUrl),
      body: {
        'username': username,
        'role': 'channel',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        adminUsernames.add(username);
        unapprovedUsernames.remove(username);
      });
    } else {
      throw Exception('Failed to update user role');
    }
  }

  bool isUserAdmin(String username) {
    return adminUsernames.contains(username);
  }

  bool isUserUnapproved(String username) {
    return unapprovedUsernames.contains(username);
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
          "Manage Admins",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                          "No admins found",
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
                      final isAdmin = isUserAdmin(username);
                      final isUnapproved = isUserUnapproved(username);

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
                                          "No Channel Name",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )
                                      else
                                        Row(
                                          children: [
                                            Text(
                                              filteredUsers[index]['fullNames'],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(width: 3),
                                            const Icon(Icons.verified,
                                                color: Colors.yellow, size: 14)
                                          ],
                                        ),
                                      Text(
                                        "@$username",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await _approveAdmin(username);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          isAdmin
                                              ? Icons.cancel
                                              : Icons.verified_user,
                                          size: 18,
                                          color: isAdmin
                                              ? Colors.red
                                              : Colors.yellow,
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          isAdmin
                                              ? "Nolonger an Admin"
                                              : "Remove Admin",
                                          style: TextStyle(
                                            color: isAdmin
                                                ? Colors.red
                                                : Colors.yellow,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      await _approveUser(username);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          isUnapproved
                                              ? Icons.cancel
                                              : Icons.verified_user,
                                          size: 18,
                                          color: isUnapproved
                                              ? Colors.red
                                              : Colors.blue,
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          isUnapproved
                                              ? "Channel Removed"
                                              : "Remove Channel",
                                          style: TextStyle(
                                            color: isUnapproved
                                                ? Colors.red
                                                : Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
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
