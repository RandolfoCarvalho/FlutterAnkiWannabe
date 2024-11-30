import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;


Future<User?> signUpWithEmailAndPassword(String email, String password, String username) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      //informacoes adicionais (se quiser add mais no futuro)
      if (credential.user != null) {
        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
          'username': username,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return credential.user;
    } catch (e) {
      print("Erro no login: $e");
    }
    return null;
  }
  
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Validações básicas
      if (email.isEmpty || password.isEmpty) {
        print('Email ou senha não podem ser vazios');
        return null;
      }

      // Método padrão de login do Firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Tratamento detalhado de erros do Firebase
      switch (e.code) {
        case 'user-not-found':
          print('Nenhum usuário encontrado com este email.');
          break;
        case 'wrong-password':
          print('Senha incorreta.');
          break;
        case 'invalid-email':
          print('Email inválido.');
          break;
        case 'user-disabled':
          print('Usuário desabilitado.');
          break;
        default:
          print('Erro de autenticação: ${e.message}');
      }
      return null;
    } catch (e) {
      print('Erro inesperado durante o login: $e');
      return null;
    }
  }
}




