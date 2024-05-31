import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:toktok/api_config.dart';
import 'package:toktok/auth/signin.dart';

// ignore: must_be_immutable
class ResetPasswordPhone extends StatelessWidget {
  final String phoneNumber;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _password;
  final RxBool isObscure = true.obs;

  Future<void> _resetPassword() async {
    final response = await http.post(
      Uri.parse(ApiConfig.resetPasswordWithPhoneUrl),
      body: {
        'phoneNumber': _contactController.text,
        'password': _passwordController.text,
      },
    );

    String responseBody = response.body;
    if (response.statusCode == 200) {
      switch (responseBody) {
        case 'update_successful':
          Get.offAll(() => const SignInPage());
          Get.snackbar(
            'Successfully',
            'Changed your password',
            backgroundColor: Colors.grey,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
          );
          break;
        case 'update_failed':
          Get.snackbar(
            'Error',
            'There was an error with changing your password. Please try again.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
          );
          break;
        default:
          Get.snackbar(
            'Error',
            'An unknown error occurred during the update process',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
          );
      }
    } else {
      Get.snackbar(
        'Error',
        'Failed to change your password. Please try again later.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    }
  }

  ResetPasswordPhone({super.key, required this.phoneNumber}) {
    _contactController.text = phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Column(children: [
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
            const SizedBox(height: 50),
            const Text(
              'Reset Password',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              "For security purposes, we recommend that you choose a new strong password which you don't use else-where",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _contactController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
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
                            return 'Please choose your new password';
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
                          labelText: 'Choose new Password',
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
                            return 'Please re-enter your new password';
                          }
                          if (value != _password) {
                            return 'Passwords must match';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Re-enter new Password',
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
                        _resetPassword();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.greenAccent),
                    child: const Text(
                      'Save Changes',
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
          ]),
        ),
      ),
    );
  }
}
