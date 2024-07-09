import 'dart:convert';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok/api_config.dart';
import 'package:toktok/pages/donate_page/profile_donation.dart';
import 'package:toktok/pages/inbox_page/chat_page.dart';
import 'package:toktok/pages/profile_page/follow_page.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});
  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  List<dynamic> users = [];
  List<dynamic> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  Set<String> fetchedUsers = {};
  int _expandedIndex = -1;

  Future<void> fetchUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId == null) {
      throw Exception('No user ID found in SharedPreferences');
    }

    final response = await http.post(
      Uri.parse(ApiConfig.fetchChannelsforDonationUrl),
      body: {'userid': userId, 'role': 'user'},
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

        fetchedUsers = users.map((user) => user['userid'].toString()).toSet();
      });
    } else {
      fetchUsers();
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
    fetchUsers();
    searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterUsers);
    searchController.dispose();
    super.dispose();
  }

  void _toggleExpansion(int index) {
    setState(() {
      if (_expandedIndex == index) {
        _expandedIndex = -1;
      } else {
        _expandedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(
          Icons.volunteer_activism,
          color: Colors.white,
        ),
        title: const Text(
          "Donate to a channel",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
          )
        ],
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
                              "No Channels found",
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
                          onTap: () {
                            _toggleExpansion(index);
                          },
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
                                      const Spacer(),
                                      if (_expandedIndex == index)
                                        const Icon(Icons.expand_less,
                                            color: Colors.white)
                                      else
                                        const Icon(Icons.expand_more,
                                            color: Colors.white),
                                    ],
                                  ),
                                  if (_expandedIndex == index)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10),
                                        const Divider(),
                                        const Text(
                                          "About this channel",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 17),
                                        ),
                                        if (filteredUsers[index]['biography']
                                            .isNotEmpty)
                                          ExpandableText(
                                            filteredUsers[index]['biography'],
                                            style: const TextStyle(
                                                color: Colors.white),
                                            expandText: 'More',
                                            collapseText: 'Less',
                                            expandOnTextTap: true,
                                            collapseOnTextTap: true,
                                            maxLines: 2,
                                            linkColor: Colors.blueGrey,
                                          )
                                        else
                                          const Text(
                                            'No About',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        const Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(FollowPage(
                                                    userId: filteredUsers[index]
                                                        ['userid']));
                                              },
                                              child: const Card(
                                                color: Colors.greenAccent,
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.remove_red_eye,
                                                          size: 18,
                                                          color: Colors.white),
                                                      SizedBox(width: 5),
                                                      Text("Profile",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(ChatPage(
                                                    userId: filteredUsers[index]
                                                        ['userid'],
                                                    username:
                                                        filteredUsers[index]
                                                            ['username'],
                                                    fullNames:
                                                        filteredUsers[index]
                                                            ['fullNames'],
                                                    profilePic:
                                                        filteredUsers[index]
                                                            ['profilePic'],
                                                    role: filteredUsers[index]
                                                        ['role']));
                                              },
                                              child: const Card(
                                                color: Colors.blue,
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.chat,
                                                          size: 18,
                                                          color: Colors.white),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        "Message",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(ProfileDonation(
                                                    userId: filteredUsers[index]
                                                        ['userid'],
                                                    username:
                                                        filteredUsers[index]
                                                            ['username'],
                                                    fullNames:
                                                        filteredUsers[index]
                                                            ['fullNames'],
                                                    profilePic:
                                                        filteredUsers[index]
                                                            ['profilePic'],
                                                    role: filteredUsers[index]
                                                        ['role']));
                                              },
                                              child: const Card(
                                                color: Colors.greenAccent,
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .volunteer_activism,
                                                          size: 18,
                                                          color: Colors.white),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        "Donate",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
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
            ),
          ],
        ),
      ),
    );
  }
}
