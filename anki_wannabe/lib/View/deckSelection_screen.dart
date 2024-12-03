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
      appBar: AppBar(
        title: Text('Meus Decks'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _userDecks.isEmpty
              ? Center(child: Text('Nenhum deck encontrado'))
              : ListView.builder(
                  itemCount: _userDecks.length,
                  itemBuilder: (context, index) {
                    final deck = _userDecks[index];
                    return ListTile(
                      title: Text(deck.name),
                      onTap: () {
                        // Navegar para a tela de estudo e passar o deckId
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
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar para tela de criação de novo deck
          Navigator.pushNamed(context, '/create-deck');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}