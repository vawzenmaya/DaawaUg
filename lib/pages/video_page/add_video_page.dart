import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toktok/api_config.dart';
import 'package:toktok/pages/video_page/approve_channels.dart';
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
                    style: TextStyle(
                      fontSize: 14,
                    ),
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
                    style: TextStyle(
                      fontSize: 14,
                    ),
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
                    style: TextStyle(
                      fontSize: 14,
                    ),
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
                            color: Colors.yellow, size: 20)
                      else if (_role == "channel")
                        const Icon(Icons.verified, color: Colors.blue, size: 20)
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
                        height: 150,
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
                                    color: Colors.grey,
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
                        height: 150,
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
                                    color: Colors.grey,
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
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.approval,
                                      color: Colors.yellow,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Approve New Channels",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ),
                  )
                ],
              ),
            const SizedBox(height: 10),
            const TextField()
          ],
        ),
      ),
    );
  }
}
