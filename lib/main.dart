// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:toktok/auth/signin.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:toktok/bottom_menu.dart';
// import 'package:provider/provider.dart';
// import 'package:toktok/pages/chat_provider.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();

//   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//     statusBarColor: Colors.transparent,
//     statusBarIconBrightness: Brightness.light,
//   ));
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => ChatProvider(),
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'DaawaTok UG Application',
//       theme: ThemeData.dark(),
//       home: const SplashScreen(),
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   Widget build(BuildContext context) {
//     Future.delayed(const Duration(seconds: 5), () async {
//       bool isLoggedIn = await checkLoginStatus();
//       if (isLoggedIn) {
//         Get.offAll(() => const BottomMainMenu());
//       } else {
//         Get.offAll(
//           () => const SignInPage(),
//           transition: Transition.size,
//           duration: const Duration(milliseconds: 500),
//         );
//       }
//     });
//     return Scaffold(
//         backgroundColor: Colors.black,
//         body: Column(
//           children: [
//             const Spacer(),
//             Center(
//               child: Column(
//                 children: [
//                   Image.asset(
//                     'assets/icon/jgot.png',
//                     width: 150,
//                     height: 150,
//                   ),
//                   const Text(
//                     'DaawaTok',
//                     style: TextStyle(
//                         color: Colors.greenAccent,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             const Text(
//               'from',
//               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
//             ),
//             const SizedBox(height: 5),
//             const Text(
//               '©DaawaTok Uganda',
//               style: TextStyle(color: Colors.grey),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ));
//   }

//   Future<bool> checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('isLoggedIn') ?? false;
//   }
// }




import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:toktok/auth/signin.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok/bottom_menu.dart';
import 'package:toktok/pages/chat_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DaawaTok UG Application',
        //theme: ThemeData(textTheme: GoogleFonts.varelaRoundTextTheme()),
        theme: ThemeData.dark(),
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool debugMode = true;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () async {
      bool isLoggedIn = await checkLoginStatus();
      if (isLoggedIn) {
        Get.offAll(() => const BottomMainMenu());
      } else {
        Get.offAll(
          () => const SignInPage(),
          transition: Transition.size,
          duration: const Duration(milliseconds: 500),
        );
      }
    });
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            const Spacer(),
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/icon/jgot.png',
                    width: 150,
                    height: 150,
                  ),
                  const Text(
                    'DaawaTok',
                    style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Text(
              'FROM',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            const Text(
              '©DaawaTok Uganda',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
          ],
        ));
  }

  Future<bool> checkLoginStatus() async {
    if (debugMode) {
      return true;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isLoggedIn')?? false;
    }
  }
}