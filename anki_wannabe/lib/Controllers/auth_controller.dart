// controllers/auth_controller.dart
import 'package:firebase_auth/firebase_auth.dart';

import '../services/firebase_service.dart';
import '../models/user_model.dart';

class AuthController {
  final FirebaseService _auth = FirebaseService();

  Future<User?> register(String email, String password, String username) {
    return _auth.signUpWithEmailAndPassword(email, password, username);
  }

  Future<User?> login(String email, String password) {
    return _auth.signInWithEmailAndPassword(email, password);
  }

  /*Future<void> logout() {
    return _authService.logout();
  }

  bool isLoggedIn() {
    return _authService.getCurrentUser() != null;
  } */
}
