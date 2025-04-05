import 'dart:convert';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok/api_config.dart';
import 'package:toktok/auth/signin.dart';
import 'package:toktok/pages/profile_page/channels_page.dart';
import 'package:toktok/pages/profile_page/drawer.dart';
import 'package:toktok/pages/profile_page/edit_profile.dart';
import 'package:toktok/pages/profile_page/followers_page.dart';
import 'package:toktok/pages/profile_page/payment_details.dart';
import 'package:toktok/pages/profile_page/privacy_policies_page.dart';
import 'package:toktok/pages/profile_page/tab_videos.dart';
import 'package:toktok/pages/profile_page/tab_favorites.dart';
import 'package:toktok/pages/profile_page/tab_liked.dart';
import 'package:toktok/pages/profile_page/unfollow_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = '';
  String _fullNames = '';
  String _biography = '';
  String _profilePic = ApiConfig.emptyProfilePicUrl;
  String _role = '';
  int followingCount = 0;
  int followerCount = 0;
  int likesCount = 0;

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userid = prefs.getString('userID') ?? '';

    final response = await http.get(
      Uri.parse(ApiConfig.getUserDataUrl(userid)),
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId == null) {
      throw Exception('No user ID found in SharedPreferences');
    }

    final response = await http.post(
      Uri.parse(ApiConfig.fetchFollowingUrl),
      body: {'userid': userId},
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId == null) {
      throw Exception('No user ID found in SharedPreferences');
    }

    final response = await http.post(
      Uri.parse(ApiConfig.fetchFollowerUrl),
      body: {'userid': userId},
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId == null) {
      throw Exception('No user ID found in SharedPreferences');
    }

    final response = await http.post(
      Uri.parse(ApiConfig.fetchAccountLikesUrl),
      body: {'userid': userId},
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
                        const Icon(Icons.verified,
                            color: Colors.yellow, size: 18)
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
          backgroundColor: Colors.white70,
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.settings,
                            color: Colors.black,
                          ),
                          title: const Text(
                            "Settings",
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          title: const Text(
                            "Privacy",
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PrivacyPoliciesPage()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.logout,
                            color: Colors.black,
                          ),
                          title: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('isLoggedIn', false);
                            Get.offAll(() => const SignInPage());
                            Get.snackbar(
                              'Successfully',
                              'Logged out',
                              snackPosition: SnackPosition.TOP,
                              duration: const Duration(seconds: 5),
                            );
                          },
                        ),
                      ],
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(
                        color: Colors.white,
                        style: BorderStyle.solid,
                        width: 2.0,
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        drawer: const ProfilePageDrawer(),
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
            if (_role == "admin" || _role == "channel")
              const SizedBox(height: 5),
            if (_role == "admin" || _role == "channel")
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(const UnfollowChannelsPage());
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
                        Get.to(const FollowersPage());
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
                    Get.to(const EditProfilePage());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        border: Border.all(color: Colors.greenAccent),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("Edit profile",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                if (_role == "admin" || _role == "channel")
                  GestureDetector(
                    onTap: () {
                      Get.to(const PaymentDetails());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          border: Border.all(color: const Color.fromARGB(255, 208, 233, 221)),
                          borderRadius: BorderRadius.circular(5)),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text("Payment Details",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () {
                      Get.to(const UnfollowChannelsPage());
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
                    Get.to(const FollowChannelsPage());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.person_add,
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
            // Tab controller
            const TabBar(
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.post_add),
                      SizedBox(width: 5),
                      Text('Videos'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark),
                      SizedBox(width: 5),
                      Text('Favorites'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite),
                      SizedBox(width: 5),
                      Text('Liked'),
                    ],
                  ),
                ),
              ],
              labelColor: Colors.black,
            ),

            const Expanded(
              child: TabBarView(
                children: [
                  VideosTab(),
                  FavoritesTab(),
                  LikedTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
