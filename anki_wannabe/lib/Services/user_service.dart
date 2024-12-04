// services/user_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> fetchCurrentUserData() async {
    try {

      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get();

        return {
          'id': currentUser.uid,
          'email': currentUser.email,
          'username': userDoc.get('username') ?? ''
        };
      }
      return null;
    } catch (e) {
      print('Erro ao buscar dados do usuário: $e');
      return null;
    }
  }

  Future<bool> updateProfile({
    String? username,
    String? email,
    String? currentPassword,
    String? newPassword,
  }) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Atualiza username no Firestore
      if (username != null) {
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .update({'username': username});
      }

      // Reauthentication
      if ((email != null || newPassword != null) && currentPassword != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: currentUser.email!,
          password: currentPassword,
        );
        await currentUser.reauthenticateWithCredential(credential);

        // Atualiza email
        if (email != null) {
          await currentUser.verifyBeforeUpdateEmail(email);
        }

        // Atualiza senha
        if (newPassword != null) {
          await currentUser.updatePassword(newPassword);
        }
      }

      return true;
    } catch (e) {
      print('Erro ao atualizar perfil: $e');
      return false;
    }
  }

  Future<void> deleteAccount() async {
  try {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('Usuário não autenticado');
    }

    // Deletar documento do usuário no Firestore
    await _firestore.collection('users').doc(currentUser.uid).delete();

    // Deletar conta de autenticação
    await currentUser.delete();
  } on FirebaseException catch (e) {
    debugPrint("Failed with error '${e.code}': ${e.message}");
    throw Exception(e.message);
  }
 }
}