import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toktok/api_config.dart';
import 'package:toktok/bottom_menu.dart';

class EditProfilePic extends StatefulWidget {
  const EditProfilePic({super.key});
  @override
  State<EditProfilePic> createState() => _EditProfilePicState();
}

class _EditProfilePicState extends State<EditProfilePic> {
  String _profilePic = ApiConfig.emptyProfilePicUrl;
  XFile? _selectedImage;
  bool _imageSelected = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userid = prefs.getString('userID');
      if (userid != null) {
        final response = await http.get(
          Uri.parse(ApiConfig.getUserDataUrl(userid)),
        );
        if (response.statusCode == 200) {
          final userData = json.decode(response.body);
          setState(() {
            _profilePic = userData['profilePic'] ?? '';
          });
        } else {
          Get.snackbar(
            'Error',
            'Failed to fetch your data',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
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

  Future<void> _saveChanges() async {
    if (_selectedImage == null) {
      Get.back();
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userid = prefs.getString('userID');
      if (userid != null) {
        String? imageBase64 = _selectedImage != null
            ? base64Encode(File(_selectedImage!.path).readAsBytesSync())
            : null;
        final response = await http.post(
          Uri.parse(ApiConfig.updateUserProfilePicUrl),
          body: {
            'userid': userid,
            'profilePic': imageBase64,
          },
        );

        final responseData = json.decode(response.body);
        if (response.statusCode == 200 && responseData['status'] == 'success') {
          Get.to(const BottomMainMenu());
          Get.snackbar(
            'Success',
            'Profile Picture updated successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        } else {
          if (responseData['status'] == 'error') {
            Get.snackbar(
              'Sorry',
              responseData['message'] ?? 'Failed to update profile picture',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
            );
          } else {
            Get.snackbar(
              'Error',
              'Failed to update profile picture',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
            );
          }
        }
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

  Future<void> _deleteProfilePic() async {
    if (_profilePic != ApiConfig.emptyProfilePicUrl) {
      bool? confirmDeletion = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Deletion',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: const Text(
              'Are you sure you want to delete your profile picture?',
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.greenAccent)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirmDeletion != null && confirmDeletion) {
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? userid = prefs.getString('userID');
          if (userid != null) {
            final response = await http.post(
              Uri.parse(ApiConfig.deleteUserProfilePicUrl),
              body: {
                'userid': userid,
              },
            );

            final responseData = json.decode(response.body);
            if (response.statusCode == 200 &&
                responseData['status'] == 'success') {
              setState(() {
                _profilePic = ApiConfig.emptyProfilePicUrl;
                _selectedImage = null;
                _imageSelected = false;
              });
              Get.to(const BottomMainMenu());
              Get.snackbar(
                'Success',
                'Profile picture deleted successfully',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
              );
            } else {
              Get.snackbar(
                'Error',
                'Failed to delete profile picture',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
              );
            }
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.close),
          color: Colors.black,
        ),
        title: const Text(
          "Profile Picture",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                children: [
                  if (!_imageSelected || _selectedImage == null)
                    if (_profilePic != ApiConfig.emptyProfilePicUrl)
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                          image: DecorationImage(
                            image: NetworkImage(_profilePic),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 150,
                        height: 150,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: const ClipOval(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 150,
                          ),
                        ),
                      )
                  else if (_selectedImage != null)
                    Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.file(
                          File(_selectedImage!.path),
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(90, 125, 0, 0),
                    child: GestureDetector(
                      onTap: getImage,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.image,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _deleteProfilePic,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.delete_forever, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'Delete',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.save, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          ' Save ',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getImage() async {
    bool? isCamera = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Camera",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.photo_library,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Gallery",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (isCamera == null) return;

    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );

    setState(() {
      _selectedImage = image;
      _imageSelected = true;
    });
  }
}
