// models/user.dart
import 'flashcard.dart';

class User {
  String username;
  List<Flashcard> flashcards;

  User({required this.username}) : flashcards = [];
}