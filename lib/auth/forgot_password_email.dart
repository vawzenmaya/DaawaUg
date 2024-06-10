import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordPageEmail extends StatelessWidget {
  final String emailAddress;
  final TextEditingController _contactController = TextEditingController();

  ForgotPasswordPageEmail({super.key, required this.emailAddress}) {
    _contactController.text = emailAddress;
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
                'We will send the instructions to reset your password through this email',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Get.snackbar(
                    'Check your Email',
                    'Password reset link has been sent there',
                    snackPosition: SnackPosition.TOP,
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.greenAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Reset Password',
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
