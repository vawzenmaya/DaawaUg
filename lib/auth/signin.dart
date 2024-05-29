import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toktok/auth/forgot_password_email.dart';
import 'package:toktok/auth/forgot_password_phone.dart';
import 'package:toktok/auth/signup.dart';
import 'package:toktok/navigation_container.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _contactController = TextEditingController();
  bool _isValidContact = false;
  bool isExampleVisible = true;
  final RxBool isObscure = true.obs;

  void toggleExampleVisibility() {
    setState(() {
      isExampleVisible = !isExampleVisible;
    });
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
              const SizedBox(height: 80),
              const Row(
                children: [
                  Text(
                    'Sign In',
                    style: TextStyle(
                        color: Colors.greenAccent, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              TextField(
                controller: _contactController,
                enabled: isExampleVisible,
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
                      Obx(() => TextField(
                            obscureText: isObscure.value,
                            decoration: InputDecoration(
                              labelText: 'Password',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              if (_isValidContact) {
                                if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(_contactController.text.trim())) {
                                  Get.to(ForgotPasswordPageEmail(
                                      emailAddress:
                                          _contactController.text.trim()));
                                } else if (RegExp(r'^[0-9]{10}$')
                                    .hasMatch(_contactController.text.trim())) {
                                  Get.to(ForgotPasswordPagePhone(
                                      phoneNumber:
                                          _contactController.text.trim()));
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
                          if (!isExampleVisible) {
                            if (_isValidContact) {
                              if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(_contactController.text.trim())) {
                                Get.offAll(() => const NavigationContainer());
                                Get.snackbar(
                                  'Successfully',
                                  'Signed in with Email',
                                  backgroundColor: Colors.grey,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.TOP,
                                );
                              } else if (RegExp(r'^[0-9]{10}$')
                                  .hasMatch(_contactController.text.trim())) {
                                Get.offAll(() => const NavigationContainer());
                                Get.snackbar(
                                  'Successfully',
                                  'Signed in with Phone Number',
                                  backgroundColor: Colors.grey,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.TOP,
                                );
                              }
                            }
                          } else {
                            setState(() {
                              isExampleVisible = false;
                            });
                          }
                        }
                      : () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: _isValidContact
                        ? Colors.greenAccent
                        : const Color.fromARGB(255, 221, 221, 221),
                  ),
                  child: Text(
                    isExampleVisible ? 'Next' : 'Login',
                    style: TextStyle(
                      color: _isValidContact ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )),
              const SizedBox(height: 50),
              const Text(
                'Or sign in with',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Get.offAll(() => const NavigationContainer());
                      Get.snackbar(
                        'Successfully',
                        'Signed in with Google',
                        backgroundColor: Colors.grey,
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
                      Get.offAll(() => const NavigationContainer());
                      Get.snackbar(
                        'Successfully',
                        'Signed in with Facebook',
                        backgroundColor: Colors.grey,
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
                      Get.offAll(() => const NavigationContainer());
                      Get.snackbar(
                        'Successfully',
                        'Signed in with Twitter',
                        backgroundColor: Colors.grey,
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
