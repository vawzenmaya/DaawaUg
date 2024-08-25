// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok/api_config.dart';
import 'package:toktok/bottom_menu.dart';
import 'package:video_player/video_player.dart';
import 'package:lottie/lottie.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class UploadScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const UploadScreen(
      {super.key, required this.videoFile, required this.videoPath});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late VideoPlayerController _controller;
  TextEditingController audioNameTextEditingController =
      TextEditingController();
  TextEditingController captionTextEditingController = TextEditingController();
  bool showProgressBar = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> uploadVideo() async {
    setState(() {
      showProgressBar = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');
    String videoTitle = audioNameTextEditingController.text;
    String description = captionTextEditingController.text;

    if (userId == null) {
      setState(() {
        showProgressBar = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User ID not found in SharedPreferences")),
      );
      return;
    }

    var uri = Uri.parse(ApiConfig.uploadVideoUrl);
    var request = http.MultipartRequest('POST', uri)
      ..fields['userid'] = userId
      ..fields['videotitle'] = videoTitle
      ..fields['description'] = description
      ..files.add(
        await http.MultipartFile.fromPath(
          'video',
          widget.videoPath,
          contentType:
              MediaType.parse(lookupMimeType(widget.videoPath) ?? 'video/mp4'),
        ),
      );

    // print('Sending request...');
    var response = await request.send();
    //print('Request sent.');

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);
      if (jsonResponse['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Video uploaded successfully")),
        );
        Get.offAll(() => const BottomMainMenu());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Failed to upload video: ${jsonResponse['message']}")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to upload video. Server error.")),
      );
    }

    setState(() {
      showProgressBar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.3,
              child: _controller.value.isInitialized
                  ? Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 30),
            showProgressBar
                ? Container(
                    child: Lottie.asset(
                      'assets/loading.json',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    children: [
                      // Video Title input
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: audioNameTextEditingController,
                          decoration: const InputDecoration(
                            labelText: "Title",
                            labelStyle: TextStyle(color: Colors.white),
                            icon: Icon(
                              Icons.music_note_sharp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Description input
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: captionTextEditingController,
                          decoration: const InputDecoration(
                            labelText: "Description",
                            labelStyle: TextStyle(color: Colors.white),
                            icon: Icon(
                              Icons.slideshow_sharp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Upload button
                      Container(
                        width: MediaQuery.of(context).size.width - 38,
                        height: 54,
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: InkWell(
                          onTap: uploadVideo,
                          child: const Center(
                            child: Text(
                              "Upload",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
