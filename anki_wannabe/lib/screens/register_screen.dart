import 'package:flutter/material.dart';
import 'sucess_screen.dart';
class RegisterScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Nome de usario"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // criando user so pra teste
                String username = usernameController.text;
                String password = passwordController.text;
                usernameController.clear();
                passwordController.clear();

                // sucesso login
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SuccessScreen(),
                  ),
                );
              },
              child: Text("Registrar"),
            ),
          ],
        ),
      ),
    );
  }
}
