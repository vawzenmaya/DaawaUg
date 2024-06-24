import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toktok/pages/video_page/upload_screen.dart';

class AddVideoPage extends StatefulWidget {
  const AddVideoPage({super.key});

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
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
                  Icons.image,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/upload.png",
              width: 260,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                displayDialogBox(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                "Upload New Video",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
