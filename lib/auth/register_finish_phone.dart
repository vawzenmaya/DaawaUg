import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toktok/auth/signin.dart';
import 'package:toktok/navigation_container.dart';

class RegisterFinishPhone extends StatelessWidget {
  final String phoneNumber;
  final TextEditingController _contactController = TextEditingController();
  final RxBool isObscure = true.obs;

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
              TextField(
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
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Full Real Names',
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
              Obx(() => TextField(
                    obscureText: isObscure.value,
                    decoration: InputDecoration(
                      labelText: 'Choose Password',
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
                          color: isObscure.value
                              ? Colors.grey
                              : Colors.greenAccent,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: 10),
              Obx(() => TextField(
                    obscureText: isObscure.value,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
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
                  Get.offAll(() => const NavigationContainer());
                  Get.snackbar(
                    'Successfully',
                    'Signed up with Phone Number',
                    backgroundColor: Colors.grey,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.greenAccent),
                child: const Text(
                  'Register',
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
            ],
          ),
        ),
      ),
    );
  }
}
