import 'package:anki_wannabe/View/study_screen.dart';
import 'package:flutter/material.dart';
import '../controllers/deck_controller.dart';
import '../models/deck_model.dart';

class DeckSelectionScreen extends StatefulWidget {
  @override
  _DeckSelectionScreenState createState() => _DeckSelectionScreenState();
}

class _DeckSelectionScreenState extends State<DeckSelectionScreen> {
  final DeckController _deckController = DeckController();
  List<Deck> _userDecks = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserDecks();
  }

  void _loadUserDecks() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final decks = await _deckController.getUserDecks();
      setState(() {
        _userDecks = decks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar decks: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Meus Decks', 
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _userDecks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox, 
                        size: 100, 
                        color: Colors.grey[300]
                      ),
                      Text(
                        'Nenhum deck encontrado', 
                        style: TextStyle(
                          color: Colors.grey, 
                          fontSize: 18
                        ),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _userDecks.length,
                  itemBuilder: (context, index) {
                    final deck = _userDecks[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3)
                          )
                        ]
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                        ),
                        title: Text(
                          deck.name, 
                          style: TextStyle(
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios, 
                          size: 18, 
                          color: Colors.grey
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudyDeckScreen(
                                deckId: deck.id.toString(), 
                                deckName: deck.name,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[700],
        onPressed: () {
          Navigator.pushNamed(context, '/deck');
        },
        child: Icon(
          Icons.add, 
          color: Colors.white
        ),
      ),
    );
  }
}