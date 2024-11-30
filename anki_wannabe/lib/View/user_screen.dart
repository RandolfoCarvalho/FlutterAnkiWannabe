// View/User_screen.dart
import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final UserController _userController = UserController();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;

  String _currentUsername = '';
  String _currentEmail = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _loadUserData();
  }

  void _initControllers() {
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
  }

  void _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userData = await _userController.getUserProfile();
      print("Dados do usuário: $userData");
      
      if (userData != null) {
        setState(() {
          _currentUsername = userData['username'] ?? '';
          _currentEmail = userData['email'] ?? '';
          _usernameController.text = _currentUsername;
          _emailController.text = _currentEmail;
        });
      } else {
        // Se não há usuário autenticado, redireciona pro login
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
      Navigator.of(context).pushReplacementNamed('/login');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateProfile() async {
    //se formulario valido...
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final success = await _userController.updateUserProfile(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim() != '' 
        ? _emailController.text.trim() 
        : null,
      currentPassword: _currentPasswordController.text.trim() != ''
        ? _currentPasswordController.text.trim()
        : null,
      newPassword: _newPasswordController.text.trim() != ''
        ? _newPasswordController.text.trim()
        : null,
    );

    if (success) {
      // Recarrega os dados do usuário após atualização
      _loadUserData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );

      // Limpa os campos de senha
      _currentPasswordController.clear();
      _newPasswordController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar perfil')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
Widget build(BuildContext context) {
  if (_isLoading) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  return Scaffold(
    appBar: AppBar(title: Text('Editar Perfil')),
    body: SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Formulário de edição
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Nome de usuario'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Nome de usuário nao pode ser vazio'
                      : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) => value != null && value.isNotEmpty && 
                    !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)
                    ? 'Email inválido'
                    : null,
                ),
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Senha Atual'),
                  validator: (value) {
                    if ((_emailController.text.isNotEmpty || 
                         _newPasswordController.text.isNotEmpty) && 
                        (value == null || value.isEmpty)) {
                      return 'Senha atual é necessária para alteracoes';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Nova Senha'),
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 6) {
                      return 'Senha deve ter no mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateProfile,
                  child: Text('Atualizar Perfil'),
                ),
              ],
            ),
          ),

          // Seção de exibição de dados do usuário
          SizedBox(height: 30),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dados do Usuario',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(
                          text: 'Nome: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: _currentUsername),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(
                          text: 'Email: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: _currentEmail),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botão de excluir conta
          SizedBox(height: 30),
          TextButton(
            onPressed: () {
              _showDeleteAccountDialog();
            },
            child: Text(
              'Excluir Conta',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// Método para exibir o alerta de confirmação antes de excluir a conta
void _showDeleteAccountDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Tem certeza?'),
        content: Text('Essa ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o alerta
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Lógica para excluir a conta do Firebase
              _userController.deleteAccount();
              Navigator.of(context).pop(); // Fecha o alerta
            },
            child: Text('Excluir'),
          ),
        ],
      );
    },
  );
}
  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
}