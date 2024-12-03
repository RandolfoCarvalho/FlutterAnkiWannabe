import '../models/deck_model.dart';
import '../services/deck_service.dart';

class DeckController {
  final DeckService _deckService = DeckService();

  Future<Deck> createDeck({
    required String name, 
    String description = '',
    List<dynamic> cards = const [],
  }) async {
    return await _deckService.createDeck(
      name: name,
      description: description,
      cards: cards,
    );
  }

  Future<List<Deck>> getUserDecks() async {
    return await _deckService.getUserDecks();
  }

  Future<void> updateDeck(Deck deck) async {
    await _deckService.updateDeck(deck);
  }

  Future<void> deleteDeck(String deckId) async {
    await _deckService.deleteDeck(deckId);
  }
}