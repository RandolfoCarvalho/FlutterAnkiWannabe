import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Anki Wannabe',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
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
              'Olá, Estudante!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Vamos estudar hoje?',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    icon: Icons.book,
                    title: 'Estudar',
                    color: Colors.blue[400]!,
                    onTap: () {
                      Navigator.pushNamed(context, '/study', arguments: 'Deck 1');
                    },
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.dashboard,
                    title: 'Meus Decks',
                    color: Colors.green[400]!,
                    onTap: () {
                      Navigator.pushNamed(context, '/deck');
                    },
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.person,
                    title: 'Perfil',
                    color: Colors.purple[400]!,
                    onTap: () {
                      Navigator.pushNamed(context, '/user');
                    },
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.settings,
                    title: 'Configurações',
                    color: Colors.orange[400]!,
                    onTap: () {
                      // Adicionar navegação para tela de configurações
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

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}