import 'package:anki_wannabe/View/User_screen.dart';
import 'package:anki_wannabe/View/home_screen.dart';
import 'package:anki_wannabe/View/login_screen.dart';
import 'package:anki_wannabe/View/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Anki Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        //'/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/user': (context) => UserScreen(),
      },
    );
  }
}