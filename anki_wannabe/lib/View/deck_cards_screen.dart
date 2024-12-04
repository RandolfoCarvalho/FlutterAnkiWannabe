import 'package:flutter/material.dart';
import '../models/deck_model.dart';
import '../models/card_model.dart' as model; // Adicionando um alias para o card_model

import '../controllers/card_controller.dart';

class DeckCardsScreen extends StatefulWidget {
  final Deck deck;

  const DeckCardsScreen({Key? key, required this.deck}) : super(key: key);

  @override
  _DeckCardsScreenState createState() => _DeckCardsScreenState();
}

class _DeckCardsScreenState extends State<DeckCardsScreen> {
  final CardController _cardController = CardController();
  List<model.Card> _deckCards = [];
  bool _isLoading = true;

  final _frontTextController = TextEditingController();
  final _backTextController = TextEditingController();


  //form para edicao
  void _showEditCardDialog(model.Card card) {
  _frontTextController.text = card.frontText;
  _backTextController.text = card.backText;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Editar Card'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _frontTextController,
            decoration: InputDecoration(
              labelText: 'Texto da Frente',
              hintText: 'Digite o novo texto da frente do card',
            ),
          ),
          TextField(
            controller: _backTextController,
            decoration: InputDecoration(
              labelText: 'Texto do Verso',
              hintText: 'Digite o novo texto do verso do card',
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
            if (_frontTextController.text.isNotEmpty && 
                _backTextController.text.isNotEmpty) {
              try {
                // Crie um novo objeto Card com as informações atualizadas
                model.Card updatedCard = model.Card(
                  id: card.id,
                  deckId: card.deckId,
                  frontText: _frontTextController.text,
                  backText: _backTextController.text,
                );

                // Chame o método de atualização do card no CardController
                await _cardController.updateCard(updatedCard);

                // Atualize a lista de cards
                setState(() {
                  int index = _deckCards.indexWhere((c) => c.id == card.id);
                  if (index != -1) {
                    _deckCards[index] = updatedCard;
                  }
                });

                _frontTextController.clear();
                _backTextController.clear();
                Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao atualizar card: $e')),
                );
              }
            }
          },
          child: Text('Salvar'),
        ),
      ],
    ),
  );
}

  
  @override
  void initState() {
    super.initState();
    _loadDeckCards();
  }

  void _loadDeckCards() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final cards = await _cardController.getDeckCards(widget.deck.id!);
      setState(() {
        _deckCards = cards;
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

  void _showCreateCardDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Criar Novo Card'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _frontTextController,
              decoration: InputDecoration(
                labelText: 'Texto da Frente',
                hintText: 'Digite o texto da frente do card',
              ),
            ),
            TextField(
              controller: _backTextController,
              decoration: InputDecoration(
                labelText: 'Texto do Verso',
                hintText: 'Digite o texto do verso do card',
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
              if (_frontTextController.text.isNotEmpty && 
                  _backTextController.text.isNotEmpty) {
                try {
                  final newCard = await _cardController.createCard(
                    deckId: widget.deck.id!,
                    frontText: _frontTextController.text,
                    backText: _backTextController.text,
                  );
                  setState(() {
                    _deckCards.add(newCard);
                  });
                  _frontTextController.clear();
                  _backTextController.clear();
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao criar card: $e')),
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
        'Cards do Deck: ${widget.deck.name}',
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
        : _deckCards.isEmpty
            ? _buildEmptyState()
            : ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: _deckCards.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final card = _deckCards[index];
                  return _buildCardItem(card, index);
                },
              ),
    floatingActionButton: FloatingActionButton(
      onPressed: _showCreateCardDialog,
      backgroundColor: Colors.blue[600],
      child: Icon(Icons.add, color: Colors.white),
      tooltip: 'Adicionar Novo Card',
    ),
  );
}

Widget _buildCardItem(model.Card card, int index) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue[50]!, Colors.white],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
      border: Border.all(color: Colors.blue[100]!, width: 1),
    ),
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      title: Text(
        'Frente: ${card.frontText}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        'Verso: ${card.backText}',
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botão de edição
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () => _showEditCardDialog(card),
          ),
          // Botão de exclusão
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              try {
                await _cardController.deleteCard(card.id!);
                setState(() {
                  _deckCards.removeAt(index);
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao deletar card: $e')),
                );
              }
            },
          ),
        ],
      ),
    ),
  );
}

Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add,
            size: 100,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'Nenhum card neste deck',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _showCreateCardDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
            'Adicionar Primeiro Card',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            ),
          ),
        ],
      ),
    );
  }
}
