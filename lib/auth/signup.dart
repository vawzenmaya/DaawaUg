import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:toktok/api_config.dart';
import 'package:toktok/auth/register_email.dart';
import 'package:toktok/auth/register_phone.dart';
import 'package:toktok/auth/signin.dart';
//import 'package:toktok/navigation_container.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contactController = TextEditingController();
  bool _isValidContact = false;
  bool isExampleVisible = true;

  void toggleExampleVisibility() {
    setState(() {
      isExampleVisible = !isExampleVisible;
    });
  }

  Future<void> _register() async {
    final response = await http.post(
      Uri.parse(ApiConfig.checkUserUrl),
      body: {
        'email': _contactController.text,
        'phoneNumber': _contactController.text,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'error') {
        Get.snackbar(
          'User already exists',
          'This credential is already associated with onther DaawaTok account',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
        );
      } else if (responseData['status'] == 'success') {
        if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(_contactController.text.trim())) {
          Get.to(RegisterEmail(emailAddress: _contactController.text.trim()));
        } else if (RegExp(r'^[0-9]{10}$')
            .hasMatch(_contactController.text.trim())) {
          Get.to(RegisterPhone(phoneNumber: _contactController.text.trim()));
        }
      }
    } else {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _contactController.addListener(_validateContact);
  }

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  void _validateContact() {
    final String emailOrPhoneNumber = _contactController.text.trim();
    final bool isValidEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailOrPhoneNumber);
    final bool isValidPhoneNumber =
        RegExp(r'^[0-9]{10}$').hasMatch(emailOrPhoneNumber);
    setState(() {
      _isValidContact = isValidEmail || isValidPhoneNumber;
    });
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
                      decoration: const InputDecoration(
                        labelText: 'Email / Phone Number',
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
                    const Row(
                      children: [
                        Text(
                          'Example : 0711888999\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\texample@domain.com',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                        onPressed: _isValidContact
                            ? () {
                                if (_isValidContact) {
                                  if (!isExampleVisible) {
                                    if (_formKey.currentState!.validate()) {
                                      _register();
                                    }
                                  } else {
                                    setState(() {
                                      isExampleVisible = false;
                                    });
                                  }
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: _isValidContact
                              ? Colors.greenAccent
                              : const Color.fromARGB(255, 221, 221, 221),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: _isValidContact ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Or sign up with',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      // Get.offAll(() => const NavigationContainer());
                      Get.snackbar(
                        'Google services are temporarily unavailable',
                        'Sorry for the sign up inconveniences caused.',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.TOP,
                      );
                    },
                    child: Image.asset('assets/images/google.png',
                        width: 50, height: 50),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    onTap: () {
                      // Get.offAll(() => const NavigationContainer());
                      Get.snackbar(
                        'Facebook services are temporarily unavailable',
                        'Sorry for the sign up inconveniences caused.',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.TOP,
                      );
                    },
                    child: Image.asset('assets/images/facebook.png',
                        width: 40, height: 40),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    onTap: () {
                      // Get.offAll(() => const NavigationContainer());
                      Get.snackbar(
                        'Twitter / X services are temporarily unavailable',
                        'Sorry for the sign up inconveniences caused.',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.TOP,
                      );
                    },
                    child: Image.asset('assets/images/twitter.png',
                        width: 50, height: 50),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already a member? ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  InkWell(
                    onTap: () {
                      Get.offAll(
                        () => const SignInPage(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
