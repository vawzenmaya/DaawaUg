import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok/auth/signin.dart';

class ProfilePageDrawer extends StatefulWidget {
  const ProfilePageDrawer({super.key});

  @override
  State<ProfilePageDrawer> createState() => _ProfilePageDrawerState();
}

class _ProfilePageDrawerState extends State<ProfilePageDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 248, 248, 248),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Daawa Tok UG',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: const Icon(
                    Icons.settings,
                    color: Colors.blueGrey,
                    size: 30,
                  ),
                  title: const Text('Settings'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 30,
                  ),
                  title: const Text('Logout'),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool(
                        'isLoggedIn', false); // Set the login status to false
                    Get.offAll(() =>
                        const SignInPage()); // Navigate back to the choose side screen
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
