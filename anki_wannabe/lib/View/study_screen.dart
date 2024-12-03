import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudyDeckScreen extends StatefulWidget {
  final String deckId;
  final String deckName;

  StudyDeckScreen({required this.deckId, required this.deckName});

  @override
  _StudyDeckScreenState createState() => _StudyDeckScreenState();
}

class _StudyDeckScreenState extends State<StudyDeckScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot> cards = [];
  int currentCardIndex = 0;
  bool _isLoading = true;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _fetchCardsForDeck();
  }

  Future<void> _fetchCardsForDeck() async {
    try {
      // Buscar cards do deck específico
      final querySnapshot = await _firestore
          .collection('cards')
          .where('deckId', isEqualTo: widget.deckId) // Usando DocumentReference diretamente
          .get();

      setState(() {
        cards = querySnapshot.docs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar cards: $e')),
      );
    }
  }

  void _nextCard() {
    setState(() {
      if (currentCardIndex < cards.length - 1) {
        currentCardIndex++;
        _showAnswer = false;
      }
    });
  }

  void _toggleAnswer() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estudando: ${widget.deckName}'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : cards.isEmpty
              ? Center(child: Text('Nenhum card encontrado neste deck'))
              : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Contagem de cards
                      Text(
                        'Card ${currentCardIndex + 1} de ${cards.length}',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 20),

                      // Pergunta
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            cards[currentCardIndex]['frontText'] ?? 'Sem pergunta',
                            style: TextStyle(fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Mostrar/Esconder resposta
                      if (_showAnswer)
                        Card(
                          color: Colors.green[50],
                          elevation: 4,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              cards[currentCardIndex]['backText'] ?? 'Sem resposta',
                              style: TextStyle(fontSize: 20, color: Colors.black87),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                      SizedBox(height: 20),

                      // Botões de ação
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _toggleAnswer,
                            child: Text(_showAnswer ? 'Esconder Resposta' : 'Mostrar Resposta'),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: _nextCard,
                            child: Text('Próximo Card'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}