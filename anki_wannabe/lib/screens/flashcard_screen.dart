import 'package:flutter/material.dart';

class FlashcardScreen extends StatefulWidget {
  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int currentCardIndex = 0;
  bool isFront = true;

  // Lista fictícia de flashcards (frente e verso)
  final List<Map<String, String>> flashcards = [
    {"frente": "O que é Flutter?", "verso": "Um framework de UI da Google."},
    {"frente": "O que é Dart?", "verso": "A linguagem de programação usada no Flutter."},
    {"frente": "O que é um Widget?", "verso": "Um componente da interface do Flutter."},
  ];

  void nextCard(bool remembered) {
    setState(() {
      if (currentCardIndex < flashcards.length - 1) {
        currentCardIndex++;
      } else {
        currentCardIndex = 0; // Reinicia os cartões
      }
      isFront = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String deckName = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Estudando: $deckName'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isFront
                ? flashcards[currentCardIndex]["frente"]! 
                : flashcards[currentCardIndex]["verso"]!, 
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isFront = !isFront; // Vira o cartão
              });
            },
            child: Text(isFront ? 'Virar' : 'Ver frente'),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  nextCard(false);
                },
                child: Text('Esqueci'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
              ElevatedButton(
                onPressed: () {
                  nextCard(true);
                },
                child: Text('Lembrei'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
