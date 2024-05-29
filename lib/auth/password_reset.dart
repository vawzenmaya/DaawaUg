import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toktok/auth/signin.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final RxBool isObscure = true.obs;
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
              "For security purposes, we recommend that you choose a new strong password that you don't use else-where",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Obx(() => TextField(
                  obscureText: isObscure.value,
                  decoration: InputDecoration(
                    labelText: 'Choose new Password',
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.greenAccent, width: 2.5),
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        isObscure.value = !isObscure.value;
                      },
                      child: Icon(
                        isObscure.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color:
                            isObscure.value ? Colors.grey : Colors.greenAccent,
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            Obx(() => TextField(
                  obscureText: isObscure.value,
                  decoration: InputDecoration(
                    labelText: 'Re-enter new Password',
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.greenAccent, width: 2.5),
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        isObscure.value = !isObscure.value;
                      },
                      child: Icon(
                        isObscure.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color:
                            isObscure.value ? Colors.grey : Colors.greenAccent,
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Get.offAll(() => const SignInPage());
                Get.snackbar(
                  'Successfully',
                  'Reseted your Password',
                  backgroundColor: Colors.grey,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.greenAccent),
              child: const Text(
                'Save Changes',
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
