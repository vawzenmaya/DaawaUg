import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok/api_config.dart';
import 'package:toktok/auth/signin.dart';
import 'package:toktok/auth/username_text_formatters.dart';
import 'package:toktok/bottom_menu.dart';

// ignore: must_be_immutable
class RegisterFinishPhone extends StatelessWidget {
  final String phoneNumber;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _password;
  final RxBool isObscure = true.obs;

  Future<void> _signUp() async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.signupWithPhoneUrl),
        body: {
          'phoneNumber': _contactController.text,
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
      );

      String responseBody = response.body;
      if (response.statusCode == 200) {
        if (responseBody == 'username_already_taken') {
          Get.snackbar(
            'Sorry username already taken',
            'Please choose another username',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
          );
        } else if (responseBody == 'registration_failed') {
          Get.snackbar(
            'Error',
            'There was an error registering your account. Please try again.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
          );
        } else {
          final Map<String, dynamic> responseJson = json.decode(responseBody);

          if (responseJson['status'] == 'registration_successful') {
            setLoggedIn();
            saveUserID(responseJson['userid'].toString());
            Get.offAll(() => const BottomMainMenu());
            Get.snackbar(
              'Successfully',
              'Signed up with Phone Number',
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 5),
            );
          } else {
            Get.snackbar(
              'Error',
              'An unknown error occurred during registration',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 5),
            );
          }
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to register. Please try again later.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
        );
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

  Future<void> saveUserID(String userid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userID', userid);
  }

  Future<void> setLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  RegisterFinishPhone({super.key, required this.phoneNumber}) {
    _contactController.text = phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'DaawaTok',
                    style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 50,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const SizedBox(
                height: 80,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Colors.greenAccent, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _contactController,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
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
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please choose your username';
                        }
                        if (value.length < 4) {
                          return 'Username must be at least 4 characters long';
                        }
                        if (value.length > 25) {
                          return 'That username is too long';
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
                    const SizedBox(height: 10),
                    Obx(() => TextFormField(
                          controller: _passwordController,
                          obscureText: isObscure.value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please choose your password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _password = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'Choose Password',
                            labelStyle: const TextStyle(color: Colors.grey),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.greenAccent, width: 2.5),
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                isObscure.value = !isObscure.value;
                              },
                              child: Icon(
                                isObscure.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: isObscure.value
                                    ? Colors.grey
                                    : Colors.greenAccent,
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(height: 10),
                    Obx(() => TextFormField(
                          obscureText: isObscure.value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please re-enter your password';
                            }
                            if (value != _password) {
                              return 'Passwords must match';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: const TextStyle(color: Colors.grey),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.greenAccent, width: 2.5),
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                isObscure.value = !isObscure.value;
                              },
                              child: Icon(
                                isObscure.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: isObscure.value
                                    ? Colors.grey
                                    : Colors.greenAccent,
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _signUp();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: Colors.greenAccent,
                  ),
                  InkWell(
                      onTap: () {
                        Get.offAll(() => const SignInPage());
                      },
                      child: const Text(
                        '  Back to login',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent),
                      )),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
