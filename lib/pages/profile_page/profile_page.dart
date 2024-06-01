import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok/api_config.dart';
import 'package:toktok/pages/first_tab.dart';
import 'package:toktok/pages/profile_page/drawer.dart';
import 'package:toktok/pages/second_tab.dart';
import 'package:toktok/pages/third_tab.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = '';
  String _fullName = '';
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
        _fullName = responseData['fullName'] ?? 'No profile name';
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
            _fullName,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.person_add,
                color: Colors.black,
              ),
            )
          ],
        ),
        drawer: const ProfilePageDrawer(),
        body: Column(
          children: [
            Container(
              height: 120,
              width: 120,
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                '@$_username',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
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
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Following",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
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
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Followers',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
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
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Likes",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    // ignore: sort_child_properties_last
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("Edit Profile",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        border: Border.all(color: Colors.greenAccent),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ],
            ),
            Text(
              _biography,
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              _email,
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              _phoneNumber,
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              _role,
              style: TextStyle(color: Colors.grey[700]),
            ),
            // Tab controller
            const TabBar(
              tabs: [
                Tab(
                  text: 'Videos',
                ),
                Tab(
                  text: 'Favorites',
                ),
                Tab(
                  text: 'Liked',
                ),
              ],
              labelColor: Colors.black,
            ),

            const Expanded(
              child: TabBarView(
                children: [
                  FirstTab(),
                  SecondTab(),
                  ThirdTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
