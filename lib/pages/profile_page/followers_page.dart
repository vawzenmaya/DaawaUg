import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FollowersPage extends StatefulWidget {
  const FollowersPage({super.key});

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  List<dynamic> users = [];
  List<dynamic> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  Set<String> followedChannels = {};

  Future<void> fetchChannels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId == null) {
      throw Exception('No user ID found in SharedPreferences');
    }

    final response = await http.post(
      Uri.parse(ApiConfig.fetchAccountFollowersUrl),
      body: {'userid': userId},
    );

    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body).map((user) {
          if (user['userid'] is! String) {
            user['userid'] = user['userid'].toString();
          }
          return user;
        }).toList();
        filteredUsers = users;

        followedChannels =
            users.map((user) => user['userid'].toString()).toSet();
      });
    } else {
      throw Exception('Failed to load channels');
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

  @override
  void initState() {
    super.initState();
    fetchChannels();
    searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterUsers);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Your Followers',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
              child: filteredUsers.isEmpty
                  ? Center(
                      child: SingleChildScrollView(
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
                              "No followers found",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Card(
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
                                            borderRadius:
                                                BorderRadius.circular(60),
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
                                          if (filteredUsers[index]
                                                      ['fullNames'] ==
                                                  "" &&
                                              filteredUsers[index]['role'] !=
                                                  "user")
                                            const Text(
                                              "No Channel Name",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          else if (filteredUsers[index]
                                                      ['fullNames'] ==
                                                  "" &&
                                              filteredUsers[index]['role'] ==
                                                  "user")
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
                                                  filteredUsers[index]
                                                      ['fullNames'],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(width: 3),
                                                if (filteredUsers[index]
                                                        ['role'] ==
                                                    'admin')
                                                  const Icon(
                                                    Icons.verified,
                                                    color: Colors.yellow,
                                                    size: 15,
                                                  )
                                                else if (filteredUsers[index]
                                                        ['role'] ==
                                                    'channel')
                                                  const Icon(
                                                    Icons.verified,
                                                    color: Colors.blue,
                                                    size: 15,
                                                  )
                                              ],
                                            ),
                                          Text(
                                            "@${filteredUsers[index]['username']}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
