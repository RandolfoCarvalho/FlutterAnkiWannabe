import '../services/user_service.dart';

class UserController {
  final UserService _userService = UserService();


  //get
  Future<Map<String, dynamic>?> getUserProfile() {
    return _userService.fetchCurrentUserData();
  }
  //put
  Future<bool> updateUserProfile({
    String? username,
    String? email,
    String? currentPassword,
    String? newPassword,
  }) {
    return _userService.updateProfile(
      username: username,
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
  
 Future<void> deleteAccount() async {
    try {
      await _userService.deleteAccount();
    } catch (e) {
      print('Erro ao excluir conta: $e');
    }
  }
}