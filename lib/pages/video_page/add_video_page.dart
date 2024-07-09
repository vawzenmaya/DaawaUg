import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:toktok/api_config.dart';
import 'package:toktok/pages/video_page/approve_channels.dart';
import 'package:toktok/pages/video_page/manage_admins.dart';
import 'package:toktok/pages/video_page/manage_channels.dart';
import 'package:toktok/pages/video_page/upload_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddVideoPage extends StatefulWidget {
  const AddVideoPage({super.key});

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  String _username = '';
  String _fullNames = '';
  String _role = '';
  List<dynamic> users = [];
  List<dynamic> filteredUsers = [];
  TextEditingController searchController = TextEditingController();

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
        _role = responseData['role'] ?? '';
      });
    } else {
      fetchUserData();
    }
  }

  Future<void> fetchChannels() async {
    final response = await http.get(Uri.parse(ApiConfig.fetchChannelsUrl));

    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
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
    fetchUserData();
    fetchChannels();
    searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterUsers);
    searchController.dispose();
    super.dispose();
  }

  getVideoFile(ImageSource sourceVid) async {
    final videoFile = await ImagePicker().pickVideo(source: sourceVid);
    if (videoFile != null) {
      // Video upload screen
      Get.to(
        UploadScreen(
          videoFile: File(videoFile.path),
          videoPath: videoFile.path,
        ),
      );
    }
  }

  displayDialogBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () {
              getVideoFile(ImageSource.gallery);
            },
            child: const Row(
              children: [
                Icon(
                  Icons.photo_library,
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Gallery",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              getVideoFile(ImageSource.camera);
            },
            child: const Row(
              children: [
                Icon(
                  Icons.camera_alt,
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Camera",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Get.back();
            },
            child: const Row(
              children: [
                Icon(
                  Icons.cancel,
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            children: [
              if (_fullNames != "")
                Flexible(
                  child: Row(
                    children: [
                      Text(
                        _fullNames,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
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
              else
                Flexible(
                  child: Text(
                    '@$_username',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (_role == "admin" || _role == "channel")
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        displayDialogBox(context);
                      },
                      child: const SizedBox(
                        height: 125,
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload,
                                  color: Colors.greenAccent,
                                  size: 50,
                                ),
                                Text(
                                  "Upload New Video",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: const SizedBox(
                        height: 125,
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.subscriptions,
                                  color: Colors.greenAccent,
                                  size: 50,
                                ),
                                Text(
                                  "Get a channel",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (_role == "admin") const SizedBox(height: 10),
            if (_role == "admin")
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(const ApproveChannels());
                      },
                      child: const SizedBox(
                        height: 50,
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.approval,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Approve New Channels",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            if (_role == "admin") const SizedBox(height: 10),
            if (_role == "admin")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(const ManageApprovedAdmins());
                    },
                    child: const SizedBox(
                      height: 100,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.admin_panel_settings,
                                color: Colors.yellow,
                              ),
                              Text(
                                "Manage\n Approved Admins ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(const ManageApprovedChannels());
                    },
                    child: const SizedBox(
                      height: 100,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.subscriptions,
                                color: Colors.blue,
                              ),
                              Text(
                                "Manage\nApproved Channels",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
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
                        final username = filteredUsers[index]['username'];

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
                                            "@$username",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
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
