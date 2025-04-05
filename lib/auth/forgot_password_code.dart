import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:toktok/api_config.dart';
import 'package:toktok/auth/forgot_password_email_update.dart';
import 'dart:convert';

import 'package:toktok/auth/signin.dart';

class EmailPasswordRestCode extends StatefulWidget {
  final String emailAddress;

  const EmailPasswordRestCode({super.key, required this.emailAddress});

  @override
  State<EmailPasswordRestCode> createState() => _EmailPasswordRestCodeState();
}

class _EmailPasswordRestCodeState extends State<EmailPasswordRestCode> {
  bool _isCodeVerified = false;
  String _code = '';
  bool _isLoading = false;

  Future<void> verifyCode() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(ApiConfig.emailRegCodeVerificationUrl);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': widget.emailAddress,
          'code': _code,
        }),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Get.offAll(
            () => EmailPasswordUpdate(emailAddress: widget.emailAddress));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Invalid code.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred: $e',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 150),
              const Icon(
                Icons.email,
                size: 100,
                color: Colors.greenAccent,
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter the Password Reset Code',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                'The code has been sent via Email to ${widget.emailAddress}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 50),
              Center(
                child: PinCodeTextField(
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  onTextChanged: (value) {
                    setState(() {
                      _code = value.trim();
                      _isCodeVerified = value.length == 4;
                    });
                  },
                  pinTextStyle: const TextStyle(fontSize: 30),
                  autofocus: true,
                  wrapAlignment: WrapAlignment.center,
                  pinBoxHeight: 50,
                  pinBoxWidth: 50,
                  pinBoxDecoration:
                      ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                  defaultBorderColor: Colors.greenAccent,
                  hasTextBorderColor: Colors.white,
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _isCodeVerified && !_isLoading ? verifyCode : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: _isCodeVerified
                      ? Colors.greenAccent
                      : const Color.fromARGB(255, 221, 221, 221),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Verify',
                        style: TextStyle(
                          color: _isCodeVerified ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Didn't receive the code?",
                      style: TextStyle(color: Colors.grey)),
                  InkWell(
                      onTap: () {
                        // Optional: Resend code logic here
                      },
                      child: const Text('  Resend',
                          style: TextStyle(color: Colors.greenAccent)))
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_back,
                      color: Colors.greenAccent, size: 15),
                  InkWell(
                      onTap: () {
                        Get.offAll(() => const SignInPage());
                      },
                      child: const Text(
                        '  Back to login',
                        style: TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold),
                      ))
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
