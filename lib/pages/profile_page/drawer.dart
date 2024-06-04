import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok/api_config.dart';
import 'package:toktok/pages/profile_page/edit_profile.dart';

class ProfilePageDrawer extends StatefulWidget {
  const ProfilePageDrawer({super.key});

  @override
  State<ProfilePageDrawer> createState() => _ProfilePageDrawerState();
}

class _ProfilePageDrawerState extends State<ProfilePageDrawer> {
  String _username = '';
  String _fullNames = '';
  String _email = '';
  String _phoneNumber = '';
  String _biography = '';
  String _profilePic = '';
  //String _role = '';

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
          _username = responseData['username'] ?? '';
          _fullNames = responseData['fullNames'] ?? '';
          _email = responseData['email'] ?? 'No email';
          _phoneNumber = responseData['phoneNumber'] ?? '';
          _biography = responseData['biography'] ?? '';
          _profilePic = responseData['profilePic'] ?? '';
          //_role = responseData['role'] ?? '';
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
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      color: Colors.grey,
                      height: 30,
                    ),
                    Container(
                      color: Colors.white,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              "DaawaTok",
                              style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 50),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Row(
                            children: [
                              Text(
                                "My Account Info",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              if (_profilePic != "")
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: NetworkImage(_profilePic),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                )
                              else
                                Stack(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const ClipOval(
                                          child: Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                        size: 80,
                                      )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          50, 60, 0, 0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(const EditProfilePage());
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Icon(
                                              Icons.edit,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Profile Name",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  if (_fullNames != "")
                                    Text(
                                      _fullNames,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400),
                                    )
                                  else
                                    Row(
                                      children: [
                                        const Text(
                                          "Not yet set! - ",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(const EditProfilePage());
                                          },
                                          child: const Flexible(
                                            child: Text(
                                              "Click to Edit",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Text(
                                "Username:",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              const SizedBox(width: 10),
                              if (_username != "")
                                Flexible(
                                  child: Text(
                                    "@$_username",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              else
                                Row(
                                  children: [
                                    const Text(
                                      "No username! - ",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(const EditProfilePage());
                                      },
                                      child: const Flexible(
                                        child: Text(
                                          "Click to Edit",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(),
                          const Text(
                            "Biography",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          if (_biography != "")
                            Text(
                              _biography,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w400),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            )
                          else
                            Row(
                              children: [
                                const Text(
                                  "You have no bio! - ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey),
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(const EditProfilePage());
                                  },
                                  child: const Text(
                                    "Click to Edit",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 10),
                          const Row(
                            children: [
                              Text(
                                "Contact Details",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                " - (Only me) ",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                              ),
                              Icon(Icons.lock, size: 12)
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Icon(Icons.phone),
                              const SizedBox(width: 10),
                              if (_phoneNumber != "")
                                Flexible(
                                  child: Text(
                                    _phoneNumber,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              else
                                Row(
                                  children: [
                                    const Text(
                                      "No Phone Number! - ",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(const EditProfilePage());
                                      },
                                      child: const Flexible(
                                        child: Text(
                                          "Click to Edit",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const Icon(Icons.mail),
                              const SizedBox(width: 10),
                              if (_email != "")
                                Flexible(
                                  child: Text(
                                    _email,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              else
                                Row(
                                  children: [
                                    const Text(
                                      "No Email Address! - ",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(const EditProfilePage());
                                      },
                                      child: const Flexible(
                                        child: Text(
                                          "Click to Edit",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
