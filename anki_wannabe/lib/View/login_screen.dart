import 'package:anki_wannabe/Controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:anki_wannabe/View/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = AuthController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Validações básicas
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    // Mostrar indicador de carregamento
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      User? user = await _authController.login(email, password);

      Navigator.of(context).pop();

      if (user != null) {
        // Login bem-sucedido
        print("Login executed");
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // Erro no login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. wrong credentials.')),
        );
      }
    } catch (e) {
      // Fechar o indicador de carregamento em caso de erro
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Some error. Try again.')),
      );
      print('Some error $e');
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Anki wannabe',
            style: TextStyle(
              fontSize: 40, 
              fontWeight: FontWeight.bold, 
              color: Colors.blueAccent, 
            ),
          ),
          SizedBox(height: 8), 
          Text(
            'Entrar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500, 
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 40),

          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.blueGrey),
              hintText: 'Digite seu email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0), 
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent, width: 2), 
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16),

          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Senha',
              labelStyle: TextStyle(color: Colors.blueGrey),
              hintText: 'Digite sua senha',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent, width: 2), 
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            obscureText: true,
          ),
          SizedBox(height: 24),

          // Botão de Login
          ElevatedButton(
            onPressed: _signIn,
            child: Text('Entrar', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50), backgroundColor: Colors.blueAccent, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), 
              ),
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16),

          // Texto de cadastro
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Não tem uma conta? "),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text(
                  "Cadastre-se",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

}