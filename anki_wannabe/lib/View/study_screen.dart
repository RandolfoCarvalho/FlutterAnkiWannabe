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
      final querySnapshot = await _firestore
          .collection('cards')
          .where('deckId', isEqualTo: widget.deckId)
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Estudando: ${widget.deckName}',
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : cards.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.credit_card_off, 
                        size: 100, 
                        color: Colors.grey[300]
                      ),
                      Text(
                        'Nenhum card encontrado neste deck', 
                        style: TextStyle(
                          color: Colors.grey, 
                          fontSize: 18
                        ),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Contagem de cards
                      Text(
                        'Card ${currentCardIndex + 1} de ${cards.length}',
                        style: TextStyle(
                          fontSize: 16, 
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      SizedBox(height: 20),

                      // Pergunta
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3)
                            )
                          ]
                        ),
                        padding: EdgeInsets.all(20),
                        child: Text(
                          cards[currentCardIndex]['frontText'] ?? 'Sem pergunta',
                          style: TextStyle(
                            fontSize: 24, 
                            color: Colors.blue[900],
                            fontWeight: FontWeight.w600
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 20),

                      // Mostrar/Esconder resposta
                      if (_showAnswer)
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3)
                              )
                            ]
                          ),
                          padding: EdgeInsets.all(20),
                          child: Text(
                            cards[currentCardIndex]['backText'] ?? 'Sem resposta',
                            style: TextStyle(
                              fontSize: 20, 
                              color: Colors.green[900],
                              fontWeight: FontWeight.w600
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      SizedBox(height: 20),

                      // Botões de ação
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20, 
                                vertical: 12
                              )
                            ),
                            onPressed: _toggleAnswer,
                            child: Text(
                              _showAnswer ? 'Esconder Resposta' : 'Mostrar Resposta',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20, 
                                vertical: 12
                              )
                            ),
                            onPressed: _nextCard,
                            child: Text(
                              'Próximo Card',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Define a cor do texto como branca
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