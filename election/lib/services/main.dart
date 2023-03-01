import 'package:firebase_core/firebase_core.dart';
import 'package:election/services/IntoLogin.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import '../firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Container(
        decoration:  const BoxDecoration(gradient:
        LinearGradient(colors: [
          Color(0xFF516395),
          Color(0xFF614385 ),
        ])),
        child: AnimatedSplashScreen(
          backgroundColor:Colors.transparent,
            nextScreen:const IntroLogin(),
            splashIconSize: 200,
            splash: const Center(child:Icon(Icons.poll,size: 60,color: Colors.white,) ),
          ),
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
