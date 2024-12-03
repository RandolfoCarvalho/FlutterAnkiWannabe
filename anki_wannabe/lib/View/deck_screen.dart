import 'package:anki_wannabe/View/deck_cards_screen.dart';
import 'package:flutter/material.dart';
import '../controllers/deck_controller.dart';
import '../models/deck_model.dart';

class DeckScreen extends StatefulWidget {
  @override
  _DeckScreenState createState() => _DeckScreenState();
}

class _DeckScreenState extends State<DeckScreen> {
  final DeckController _deckController = DeckController();
  List<Deck> _userDecks = [];
  bool _isLoading = true;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

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

  void _showCreateDeckDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Criar Novo Deck'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome do Deck',
                hintText: 'Digite o nome do deck',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descrição (Opcional)',
                hintText: 'Digite uma descrição para o deck',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_nameController.text.isNotEmpty) {
                try {
                  final newDeck = await _deckController.createDeck(
                    name: _nameController.text,
                    description: _descriptionController.text,
                  );
                  setState(() {
                    _userDecks.add(newDeck);
                  });
                  _nameController.clear();
                  _descriptionController.clear();
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao criar deck: $e')),
                  );
                }
              }
            },
            child: Text('Criar'),
          ),
        ],
      ),
    );
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'Meus Decks',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ),
    body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : _userDecks.isEmpty
            ? _buildEmptyState()
            : ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: _userDecks.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final deck = _userDecks[index];
                  return _buildDeckCard(deck, index);
                },
              ),
    floatingActionButton: FloatingActionButton(
      onPressed: _showCreateDeckDialog,
      backgroundColor: Colors.blue[600],
      child: Icon(Icons.add, color: Colors.white),
    ),
  );
}

Widget _buildDeckCard(Deck deck, int index) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
      border: Border.all(color: Colors.grey[300]!, width: 1),
    ),
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        deck.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      subtitle: Text(
        deck.description.isNotEmpty ? deck.description : 'Sem descrição',
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () async {
          try {
            await _deckController.deleteDeck(deck.id!);
            setState(() {
              _userDecks.removeAt(index);
            });
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro ao deletar deck: $e')),
            );
          }
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeckCardsScreen(deck: deck),
          ),
        );
      },
    ),
  );
}

Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 100,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'Nenhum deck criado ainda',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _showCreateDeckDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Criar Primeiro Deck',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}