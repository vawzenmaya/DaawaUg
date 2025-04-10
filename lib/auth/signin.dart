import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok/api_config.dart';
import 'package:toktok/auth/forgot_password_email.dart';
import 'package:toktok/auth/forgot_password_phone.dart';
import 'package:toktok/auth/signup.dart';
import 'package:toktok/bottom_menu.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isValidContact = false;
  bool isExampleVisible = true;
  final RxBool isObscure = true.obs;

  void toggleExampleVisibility() {
    setState(() {
      isExampleVisible = !isExampleVisible;
    });
  }

  Future<void> _login() async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.signinUrl),
        body: {
          'email': _contactController.text,
          'phoneNumber': _contactController.text,
          'password': _passwordController.text,
        },
      );

      String responseBody = response.body;
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(responseBody);
        if (responseJson['status'] == 'success') {
          setLoggedIn();
          saveUserID(responseJson['userid'].toString());
          Get.offAll(() => const BottomMainMenu());
          Get.snackbar(
            'Successfully',
            'Signed In',
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
          );
        } else {
          Get.snackbar(
            'Incorrect Password!',
            'Please try again',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
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

  Future<void> _checkUser() async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.checkUserUrl),
        body: {
          'email': _contactController.text,
          'phoneNumber': _contactController.text,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          Get.snackbar(
            'User not found!',
            'This credential is not associated with any DaawaTok account',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
          );
        } else if (responseData['status'] == 'error') {
          setState(() {
            isExampleVisible = false;
          });
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
              const SizedBox(height: 100),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icon/jgot.png',
                    width: 200,
                    height: 200,
                  ),
                ],
              ),
              const SizedBox(height: 70),
              const Row(
                children: [
                  Text(
                    'Login',
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
                      enabled: isExampleVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email or phone number';
                        }
                        return null;
                      },
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
                    isExampleVisible
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Example : 0711888999\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\texample@domain.com',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )
                        : Column(children: [
                            Obx(() => TextFormField(
                                  controller: _passwordController,
                                  obscureText: isObscure.value,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle:
                                        const TextStyle(color: Colors.grey),
                                    border: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.greenAccent,
                                          width: 2.5),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (_isValidContact) {
                                      if (!isExampleVisible) {
                                        if (RegExp(
                                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                            .hasMatch(_contactController.text
                                                .trim())) {
                                          Get.to(ForgotPasswordPageEmail(
                                              emailAddress: _contactController
                                                  .text
                                                  .trim()));
                                        } else if (RegExp(r'^[0-9]{10}$')
                                            .hasMatch(_contactController.text
                                                .trim())) {
                                          Get.to(ForgotPasswordPagePhone(
                                              phoneNumber: _contactController
                                                  .text
                                                  .trim()));
                                        }
                                      } else {
                                        setState(() {
                                          isExampleVisible = false;
                                        });
                                      }
                                    }
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(color: Colors.greenAccent),
                                  ),
                                )
                              ],
                            )
                          ]),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: _isValidContact
                          ? () {
                              if (isExampleVisible) {
                                _checkUser();
                              } else {
                                if (_formKey.currentState!.validate()) {
                                  _login();
                                }
                              }
                            }
                          : () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: _isValidContact
                            ? Colors.greenAccent
                            : const Color.fromARGB(255, 221, 221, 221),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        isExampleVisible ? 'Next' : 'Login',
                        style: TextStyle(
                          color: _isValidContact ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                'Or Login with',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      // Get.offAll(() => const BottomMainMenu());
                      Get.snackbar(
                        'Google services are temporarily unavailable',
                        'Sorry for the login inconveniences caused.',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.TOP,
                      );
                    },
                    child: Image.asset('assets/images/google.png',
                        width: 50, height: 50),
                  ),
                  const SizedBox(width: 30),
                  InkWell(
                    onTap: () {
                      // Get.offAll(() => const BottomMainMenu());
                      Get.snackbar(
                        'Facebook services are temporarily unavailable',
                        'Sorry for the login inconveniences caused.',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.TOP,
                      );
                    },
                    child: Image.asset('assets/images/facebook.png',
                        width: 40, height: 40),
                  ),
                  const SizedBox(width: 30),
                  InkWell(
                    onTap: () {
                      // Get.offAll(() => const BottomMainMenu());
                      Get.snackbar(
                        'Twitter / X services are temporarily unavailable',
                        'Sorry for the login inconveniences caused.',
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
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No account yet? ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(
                        const SignUpPage(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                    child: const Text(
                      'Create one',
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              isExampleVisible
                  ? const Text('')
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.arrow_back,
                          size: 15,
                          color: Colors.greenAccent,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isExampleVisible = true;
                            });
                          },
                          child: const Text(
                            '  Back',
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
