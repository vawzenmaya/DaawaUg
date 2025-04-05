import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toktok/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:toktok/auth/forgot_password_code.dart';

class ForgotPasswordPageEmail extends StatelessWidget {
  final String emailAddress;
  final TextEditingController _contactController = TextEditingController();

  ForgotPasswordPageEmail({super.key, required this.emailAddress}) {
    _contactController.text = emailAddress;
  }

  Future<bool> sendEmail() async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.emailPasswordCodeUrl),
        body: {'email': _contactController.text},
      );

      if (response.statusCode == 200) {
        //  print("Email sent successfully: ${response.body}");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
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
              TextField(
                controller: _contactController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Email',
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
              const Text(
                'We will send you the password reset code through this email address',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  bool success = await sendEmail();
                  if (success) {
                    Get.to(EmailPasswordRestCode(emailAddress: emailAddress));
                  } else {
                    Get.snackbar(
                      "Error",
                      "Failed to send the password reset code",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
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
                  'Request Code',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 80),
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
                        Get.back();
                      },
                      child: const Text(
                        '  Back to login',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
