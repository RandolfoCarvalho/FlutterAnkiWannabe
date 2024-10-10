import 'package:flutter/material.dart';

class CreateDeckScreen extends StatefulWidget {
  @override
  _CreateDeckScreenState createState() => _CreateDeckScreenState();
}

class _CreateDeckScreenState extends State<CreateDeckScreen> {
  final _formKey = GlobalKey<FormState>();
  String deckName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Novo Deck'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome do Deck'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira um nome para o deck';
                  }
                  return null;
                },
                onSaved: (value) {
                  deckName = value ?? '';
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(context, deckName); // Retorna o nome do deck criado
                  }
                },
                child: Text('Criar Deck'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
