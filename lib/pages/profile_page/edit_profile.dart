import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toktok/api_config.dart';
import 'package:toktok/auth/username_text_formatters.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String _email = '';
  String _phoneNumber = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNamesController = TextEditingController();
  final TextEditingController _biographyController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString('userID');
    if (userid != null) {
      final response = await http.get(
        Uri.parse(ApiConfig.getUserDataUrl(userid)),
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          _usernameController.text = userData['username'];
          _fullNamesController.text = userData['fullNames'];
          _biographyController.text = userData['biography'];
          _phoneNumberController.text = userData['phoneNumber'];
          _emailController.text = userData['email'];
          _email = userData['email'] ?? 'No email';
          _phoneNumber = userData['phoneNumber'] ?? '';
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
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userid = prefs.getString('userID');
      if (userid != null) {
        final response = await http.post(
          Uri.parse(ApiConfig.updateUserProfileUrl),
          body: {
            'userid': userid,
            'username': _usernameController.text,
            'fullNames': _fullNamesController.text,
            'biography': _biographyController.text,
            'phoneNumber': _phoneNumberController.text,
            'email': _emailController.text,
          },
        );

        final responseData = json.decode(response.body);
        if (response.statusCode == 200 && responseData['status'] == 'success') {
          Get.back();
          Get.snackbar(
            'Success',
            'Profile updated successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        } else {
          if (responseData['status'] == 'error') {
            Get.snackbar(
              'Sorry',
              responseData['message'] ?? 'Failed to update profile',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
            );
          } else {
            Get.snackbar(
              'Error',
              'Failed to update profile',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
            );
          }
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
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      maxLength: 25,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w300),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please choose your username';
                        }
                        if (value.length < 4) {
                          return 'Username must be at least 4 characters long';
                        }
                        return null;
                      },
                      inputFormatters: [
                        LowerCaseTextFormatter(),
                        NoWhitespaceTextFormatter(),
                        AllowLettersNumbersUnderscoresDotsTextFormatter(),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Choose a username',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 2.5),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _fullNamesController,
                      maxLength: 50,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w300),
                      decoration: const InputDecoration(
                        labelText: 'Profile Name',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 2.5),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _biographyController,
                      maxLines: null,
                      maxLength: 150,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w300),
                      decoration: const InputDecoration(
                        labelText: 'Biography',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 2.5),
                        ),
                      ),
                    ),
                    if (_phoneNumber != "")
                      TextFormField(
                        controller: _phoneNumberController,
                        maxLength: 10,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w300),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          final phoneRegex = RegExp(r'^\d{10}$');
                          if (!phoneRegex.hasMatch(value)) {
                            return 'Please enter a valid 10-digit phone number';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 2.5),
                          ),
                        ),
                      )
                    else
                      TextFormField(
                        controller: _phoneNumberController,
                        maxLength: 10,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final phoneRegex = RegExp(r'^\d{10}$');
                            if (!phoneRegex.hasMatch(value)) {
                              return 'Please enter a valid 10-digit phone number';
                            }
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 2.5),
                          ),
                        ),
                      ),
                    if (_email != "")
                      TextFormField(
                        controller: _emailController,
                        maxLength: 100,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w300),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 2.5),
                          ),
                        ),
                      )
                    else
                      TextFormField(
                        controller: _emailController,
                        maxLength: 100,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 2.5),
                          ),
                        ),
                      ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
