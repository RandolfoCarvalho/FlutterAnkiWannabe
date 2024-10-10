import 'package:flutter/material.dart';
import 'flashcard_tab_screen.dart'; 

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Nome de Usuário"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String username = usernameController.text;
                String password = passwordController.text;

                if (username == 'randolfo' && password == '123') {
                  usernameController.clear();
                  passwordController.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Login realizado com sucesso")),
                  );

                  // Navega para a tela de flashcards
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FlashcardTabScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Usuario ou senha invalidos")),
                  );
                }
              },
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
