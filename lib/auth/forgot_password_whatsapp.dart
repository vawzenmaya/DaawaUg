import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:toktok/auth/password_reset_phone.dart';

class ForgotPasswordPageWhatsapp extends StatefulWidget {
  final String phoneNumber;

  const ForgotPasswordPageWhatsapp({super.key, required this.phoneNumber});

  @override
  State<ForgotPasswordPageWhatsapp> createState() =>
      _ForgotPasswordPageWhatsappState();
}

class _ForgotPasswordPageWhatsappState
    extends State<ForgotPasswordPageWhatsapp> {
  bool _isCodeVerified = false;

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
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/whatsapp.png',
                  width: 80,
                  height: 80,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter the Verification Code',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                'The password reset verification code has been sent via Whatsapp to ${widget.phoneNumber}',
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
                onPressed: _isCodeVerified
                    ? () {
                        Get.offAll(() => ResetPasswordPhone(
                              phoneNumber: widget.phoneNumber,
                            ));
                      }
                    : null,
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
                child: Text(
                  'Verify',
                  style: TextStyle(
                      color: _isCodeVerified ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Didn't receive the code?",
                      style: TextStyle(color: Colors.grey)),
                  InkWell(
                      onTap: () {},
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
                        Get.back();
                      },
                      child: const Text(
                        '  Back',
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
