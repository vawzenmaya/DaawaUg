import 'package:flutter/material.dart';
import 'package:toktok/api_config.dart';
import 'package:toktok/pages/video_page/add_video_page.dart';
import 'package:toktok/pages/donate_page/donate_page.dart';
import 'package:toktok/pages/home_page.dart';
import 'package:toktok/pages/inbox_page/inbox_page.dart';
import 'package:toktok/pages/profile_page/profile_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'dart:convert';

class BottomMainMenu extends StatefulWidget {
  const BottomMainMenu({super.key});

  @override
  State<BottomMainMenu> createState() => _BottomMainMenuState();
}

class _BottomMainMenuState extends State<BottomMainMenu> {
  int _currentIndex = 0;

  static const List<Widget> _pages = [
    HomePage(),
    DonatePage(),
    AddVideoPage(),
    InboxPage(),
    ProfilePage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String _role = '';

  Future<void> fetchUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userid = prefs.getString('userID') ?? '';

      final response = await http.get(
        Uri.parse(ApiConfig.getUserDataUrl(userid)),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        setState(() {
          _role = responseData['role'] ?? '';
        });
      } else {
        //print('Failed to fetch user details');
      }
    } catch (e) {
      Get.snackbar(
        'Network Error',
        'Check your internet connection',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            activeIcon: Icon(
              Icons.volunteer_activism,
              color: Colors.greenAccent,
            ),
            label: 'Donate',
          ),
          if (_role == "admin" || _role == "channel")
            BottomNavigationBarItem(
              icon: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.greenAccent, Colors.lightGreenAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(Icons.add),
                ),
              ),
              label: '',
            )
          else
            BottomNavigationBarItem(
              icon: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.greenAccent, Colors.lightGreenAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(Icons.tv),
                ),
              ),
              label: 'Channels',
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.email),
            label: 'Inbox',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
