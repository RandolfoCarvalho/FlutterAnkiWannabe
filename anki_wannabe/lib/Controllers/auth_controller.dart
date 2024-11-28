/*// controllers/auth_controller.dart
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<UserModel?> register(String email, String password, String username) {
    return _authService.register(email, password, username);
  }

  Future<UserModel?> login(String email, String password) {
    return _authService.login(email, password);
  }

  Future<void> logout() {
    return _authService.logout();
  }

  bool isLoggedIn() {
    return _authService.getCurrentUser() != null;
  }
}
*/