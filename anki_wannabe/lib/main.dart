import 'package:anki_wannabe/screens/create_deck_screen.dart';
import 'package:anki_wannabe/screens/flashcard_screen.dart';
import 'package:anki_wannabe/screens/flashcard_tab_screen.dart';
import 'package:anki_wannabe/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../screens/flashcard_tab_screen.dart';
import '../screens/flashcard_screen.dart';
import '../screens/create_deck_screen.dart'; // Nova tela para criar deck

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anki Wannabe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        //teste
        '/': (context) => HomeScreen(), //FlashcardTabScreen(),
        '/study': (context) => FlashcardScreen(),
        '/createDeck': (context) => CreateDeckScreen(),
      },
    );
  }
}
