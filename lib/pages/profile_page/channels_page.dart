import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FollowChannelsPage extends StatefulWidget {
  const FollowChannelsPage({super.key});

  @override
  State<FollowChannelsPage> createState() => _FollowChannelsPageState();
}

class _FollowChannelsPageState extends State<FollowChannelsPage> {
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
      Uri.parse(ApiConfig.fetchUnfollowedUrl),
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
      });
    } else {
      fetchChannels();
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

  Future<void> _followChannel(String userid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId == null) {
      throw Exception('No user ID found in SharedPreferences');
    }

    final response = await http.post(
      Uri.parse(ApiConfig.followChannelUrl),
      body: {
        'follower': userId,
        'following': userid,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        followedChannels.add(userid);
      });
    } else {
      _followChannel(userid);
    }
  }

  Future<void> _unfollowChannel(String userid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId == null) {
      throw Exception('No user ID found in SharedPreferences');
    }

    final response = await http.post(
      Uri.parse(ApiConfig.unfollowChannelUrl),
      body: {
        'follower': userId,
        'following': userid,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        followedChannels.remove(userid);
      });
    } else {
      _unfollowChannel(userid);
    }
  }

  bool isChannelFollowed(String userid) {
    return followedChannels.contains(userid);
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
          'Follow Channels',
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
                labelText: 'Search for a channel',
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
                              "No channels found",
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
                        final userid = filteredUsers[index]['userid'];
                        final isFollowed = isChannelFollowed(userid);

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
                                      const Spacer(),
                                      Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              if (isFollowed) {
                                                await _unfollowChannel(userid);
                                              } else {
                                                await _followChannel(userid);
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  isFollowed
                                                      ? Icons.check_circle
                                                      : Icons.person_add,
                                                  size: 18,
                                                  color: isFollowed
                                                      ? Colors.greenAccent
                                                      : Colors.blue,
                                                ),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  isFollowed
                                                      ? "Following"
                                                      : "Follow",
                                                  style: TextStyle(
                                                    color: isFollowed
                                                        ? Colors.greenAccent
                                                        : Colors.blue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
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
