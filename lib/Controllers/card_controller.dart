import '../models/card_model.dart';
import '../services/card_service.dart';

class CardController {
  final CardService _cardService = CardService();

  Future<Card> createCard({
    required String deckId,
    required String frontText,
    required String backText,
  }) async {
    return await _cardService.createCard(
      deckId: deckId,
      frontText: frontText,
      backText: backText,
    );
  }

  Future<List<Card>> getDeckCards(String deckId) async {
    return await _cardService.getDeckCards(deckId);
  }

  Future<void> updateCard(Card card) async {
    await _cardService.updateCard(card);
  }

  Future<void> deleteCard(String cardId) async {
    await _cardService.deleteCard(cardId);
  }
}