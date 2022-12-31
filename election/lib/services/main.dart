import 'package:election/pages/Admin/AdminHome.dart';
import 'package:election/pages/Admin/Loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:election/services/IntoLogin.dart';
import 'package:election/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedSplashScreen(
          nextScreen:IntroLogin(),
          splashIconSize: 200,
          splash: Center(child: Image.asset('assets/undraw/voting.png')),
        ),

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        primaryColor: Colors.cyan,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.cyan))),
        appBarTheme: const AppBarTheme(elevation: 0, color: Colors.transparent),
      ),
    );
  }
}
