// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo ao Anki Wannabe!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Escolha uma opção:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.dashboard),
                    title: Text('Opção 1'),
                    onTap: () {
                      // Ação para a opção 1
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Opção 2'),
                    onTap: () {
                      // Ação para a opção 2
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Editar Perfil'),
                    onTap: () {
                      Navigator.pushNamed(context, '/user');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
