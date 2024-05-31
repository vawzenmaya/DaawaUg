import 'package:flutter/material.dart';
import 'package:toktok/pages/add_video_page.dart';
import 'package:toktok/pages/donate_page.dart';
import 'package:toktok/pages/home_page.dart';
import 'package:toktok/pages/inbox_page.dart';
import 'package:toktok/pages/profile_page.dart';

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
