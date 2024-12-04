import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/card_model.dart';

class CardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // post
  Future<Card> createCard({
    required String deckId,
    required String frontText,
    required String backText,
  }) async {
    try {
      Card newCard = Card(
        deckId: deckId,
        frontText: frontText,
        backText: backText,
        createdAt: DateTime.now(),
      );

      DocumentReference docRef = await _firestore
          .collection('cards')
          .add(newCard.toMap());

      newCard.id = docRef.id;
      return newCard;
    } catch (e) {
      print('Erro ao criar card: $e');
      rethrow;
    }
  }

  // get
  Future<List<Card>> getDeckCards(String deckId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('cards')
          .where('deckId', isEqualTo: deckId)
          .get();

      return querySnapshot.docs
          .map((doc) => Card.fromMap(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Erro ao buscar cards: $e');
      rethrow;
    }
  }

  // put
  Future<void> updateCard(Card card) async {
    try {
      await _firestore
          .collection('cards')
          .doc(card.id)
          .update(card.toMap());
    } catch (e) {
      print('Erro ao atualizar card: $e');
      rethrow;
    }
  }

  // Delete
  Future<void> deleteCard(String cardId) async {
    try {
      await _firestore.collection('cards').doc(cardId).delete();
    } catch (e) {
      print('Erro ao deletar card: $e');
      rethrow;
    }
  }
}