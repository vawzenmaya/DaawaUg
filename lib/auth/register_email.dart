import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toktok/api_config.dart';
import 'package:toktok/auth/register_verify_email.dart';
import 'package:http/http.dart' as http;

class RegisterEmail extends StatelessWidget {
  final String emailAddress;

  const RegisterEmail({super.key, required this.emailAddress});

  Future<bool> sendEmail() async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.emailRegCodeUrl),
        body: {'email': emailAddress},
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
              const SizedBox(height: 150),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Choose Verification Method',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Please choose one of the methods below to get a registration verification code',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 50),
              InkWell(
                onTap: () async {
                  bool success = await sendEmail();
                  if (success) {
                    Get.to(RegisterVerifyEmail(emailAddress: emailAddress));
                  } else {
                    Get.snackbar(
                      "Error",
                      "Failed to send verification code",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.email,
                            size: 50, color: Colors.greenAccent),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email to',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                emailAddress,
                                style: const TextStyle(color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_back,
                      size: 20, color: Colors.greenAccent),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Text(
                      '  Back',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent),
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
