import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok/api_config.dart';
import 'package:toktok/auth/signin.dart';
import 'package:toktok/pages/profile_page/tab_videos.dart';
import 'package:toktok/pages/profile_page/tab_favorites.dart';
import 'package:toktok/pages/profile_page/tab_liked.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = '';
  String _fullNames = '';
  String _email = '';
  String _phoneNumber = '';
  String _biography = '';
  String _profilePic = '';
  String _role = '';

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('userName') ?? '';

    final response = await http.get(
      Uri.parse(ApiConfig.getUserDataUrl(username)),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      setState(() {
        _username = responseData['username'] ?? 'No username';
        _fullNames = responseData['fullNames'] ?? 'No profile name';
        _email = responseData['email'] ?? 'No email';
        _phoneNumber = responseData['phoneNumber'] ?? 'No phone number';
        _biography = responseData['biography'] ?? 'No biography';
        _profilePic = responseData['profilePic'] ?? 'assets/p1.jpg';
        _role = responseData['role'] ?? 'No role';
      });
    } else {
      //print('Failed to fetch user details');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            _fullNames,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white70,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.person,
              color: Colors.black,
            ),
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
                          onTap: () {},
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
        body: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                image: DecorationImage(
                  image: _profilePic.isNotEmpty
                      ? NetworkImage(_profilePic)
                      : const AssetImage('assets/p1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '@$_username',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: const Column(
                      children: [
                        Text(
                          '3',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
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
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Column(
                      children: [
                        Text(
                          '70',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
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
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: const Column(
                      children: [
                        Text(
                          '370',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
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
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(color: Colors.grey),
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
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("Share profile",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        border: Border.all(color: Colors.greenAccent),
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
            const SizedBox(height: 5),
            Text(
              _biography,
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              _email,
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              "$_phoneNumber - $_role",
              style: TextStyle(color: Colors.grey[700]),
            ),
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
