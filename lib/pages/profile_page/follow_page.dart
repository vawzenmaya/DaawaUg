import 'dart:convert';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toktok/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:toktok/pages/donate_page/profile_donation.dart';
import 'package:toktok/pages/inbox_page/chat_page.dart';

class FollowPage extends StatefulWidget {
  final String userId;
  const FollowPage({
    super.key,
    required this.userId,
  });
  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  String _username = '';
  String _fullNames = '';
  String _biography = '';
  String _profilePic = ApiConfig.emptyProfilePicUrl;
  String _role = '';
  int followingCount = 0;
  int followerCount = 0;
  int likesCount = 0;

  Future<void> fetchUserData() async {
    final response = await http.get(
      Uri.parse(ApiConfig.getUserDataUrl(widget.userId)),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      setState(() {
        _username = responseData['username'] ?? '';
        _fullNames = responseData['fullNames'] ?? '';
        _biography = responseData['biography'] ?? '';
        _profilePic = responseData['profilePic'] ?? '';
        _role = responseData['role'] ?? '';
      });
    } else {
      fetchUserData();
    }
  }

  Future<void> fetchFollowingCount() async {
    final response = await http.post(
      Uri.parse(ApiConfig.fetchFollowingUrl),
      body: {'userid': widget.userId},
    );

    if (response.statusCode == 200) {
      setState(() {
        followingCount = json.decode(response.body)['followingCount'];
      });
    } else {
      fetchFollowingCount();
    }
  }

  Future<void> fetchFollowerCount() async {
    final response = await http.post(
      Uri.parse(ApiConfig.fetchFollowerUrl),
      body: {'userid': widget.userId},
    );

    if (response.statusCode == 200) {
      setState(() {
        followerCount = json.decode(response.body)['followerCount'];
      });
    } else {
      fetchFollowerCount();
    }
  }

  Future<void> fetchAccountLikesCount() async {
    final response = await http.post(
      Uri.parse(ApiConfig.fetchAccountLikesUrl),
      body: {'userid': widget.userId},
    );

    if (response.statusCode == 200) {
      setState(() {
        likesCount = json.decode(response.body)['likesCount'];
      });
    } else {
      fetchAccountLikesCount();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchFollowingCount();
    fetchFollowerCount();
    fetchAccountLikesCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Row(
          children: [
            if (_fullNames != "")
              Flexible(
                child: Row(
                  children: [
                    Text(
                      _fullNames,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 2),
                    if (_role == "admin")
                      const Icon(Icons.verified, color: Colors.yellow, size: 18)
                    else if (_role == "channel")
                      const Icon(Icons.verified, color: Colors.blue, size: 18)
                  ],
                ),
              )
            else if (_fullNames == "" && _role != "user")
              const Flexible(
                child: Text(
                  "No channel name!",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              )
            else
              const Flexible(
                child: Text(
                  "No profile name!",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ))
        ],
      ),
      body: Column(
        children: [
          if (_profilePic != ApiConfig.emptyProfilePicUrl)
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.grey,
                image: DecorationImage(
                  image: NetworkImage(_profilePic),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: const ClipOval(
                  child: Icon(
                Icons.person,
                color: Colors.white,
                size: 100,
              )),
            ),
          const SizedBox(height: 5),
          if (_username != "")
            Text(
              '@$_username',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
            )
          else
            const Text(
              '@username!',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
            ),
          if (_role == "admin" || _role == "channel") const SizedBox(height: 5),
          if (_role == "admin" || _role == "channel")
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      //Get.to(const UnfollowChannelsPage());
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: [
                          Text(
                            '$followingCount',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const Text(
                            "Following",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Get.to(const FollowersPage());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            '$followerCount',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const Text(
                            'Followers',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Text(
                          '$likesCount',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const Text(
                          "Likes",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  //Get.to(const EditProfilePage());
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      border: Border.all(color: Colors.greenAccent),
                      borderRadius: BorderRadius.circular(5)),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Relationship",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              if (_role == "admin" || _role == "channel")
                GestureDetector(
                  onTap: () {
                    Get.to(ProfileDonation(
                        userId: widget.userId,
                        username: _username,
                        fullNames: _fullNames,
                        profilePic: _profilePic,
                        role: _role));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        border: Border.all(color: Colors.greenAccent),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.volunteer_activism,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Text("Donation",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: () {
                    // Get.to(const UnfollowChannelsPage());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        border: Border.all(color: Colors.greenAccent),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const Text(
                            "Following: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$followingCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        userId: widget.userId,
                        username: _username,
                        fullNames: _fullNames,
                        profilePic: _profilePic,
                        role: _role,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(5)),
                  child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.chat,
                        color: Colors.white,
                      )),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 250,
            child: Column(
              children: [
                if (_biography != "")
                  ExpandableText(
                    _biography,
                    style: TextStyle(color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                    expandText: 'More',
                    collapseText: 'Less',
                    expandOnTextTap: true,
                    collapseOnTextTap: true,
                    maxLines: 3,
                    linkColor: Colors.blueGrey,
                  )
                else
                  Text(
                    "No biography !",
                    style: TextStyle(color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
