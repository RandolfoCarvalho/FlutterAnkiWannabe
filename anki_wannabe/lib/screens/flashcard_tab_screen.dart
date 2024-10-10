import 'package:flutter/material.dart';

class FlashcardTabScreen extends StatefulWidget {
  @override
  _FlashcardTabScreenState createState() => _FlashcardTabScreenState();
}

class _FlashcardTabScreenState extends State<FlashcardTabScreen> {
  List<String> decks = ["Deck 1", "Deck 2", "Deck 3"]; // Lista de decks

  void addDeck(String newDeck) {
    setState(() {
      decks.add(newDeck); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Decks'),
      ),
      body: ListView.builder(
        itemCount: decks.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(decks[index]),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/study',
                  arguments: decks[index],
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navega para a tela de criação de deck
          final String? newDeckName = await Navigator.pushNamed(context, '/createDeck') as String?;
          if (newDeckName != null && newDeckName.isNotEmpty) {
            addDeck(newDeckName);
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Criar novo deck',
      ),
    );
  }
}
