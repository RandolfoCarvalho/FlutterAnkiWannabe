import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/deck_model.dart';

class DeckService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Criar um novo deck
  Future<Deck> createDeck({
    required String name, 
    String description = '',
    List<dynamic> cards = const [],
  }) async {
    try {
      // Obtém o ID do usuário atual
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      // Cria o objeto Deck
      Deck newDeck = Deck(
        userID: currentUser.uid,
        name: name,
        description: description,
        cards: cards,
      );

      // Adiciona ao Firestore
      DocumentReference docRef = await _firestore
          .collection('decks')
          .add(newDeck.toMap());

      // Atualiza o ID do deck
      newDeck.id = docRef.id;
      return newDeck;
    } catch (e) {
      print('Erro ao criar deck: $e');
      rethrow;
    }
  }

  // get
  Future<List<Deck>> getUserDecks() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      QuerySnapshot querySnapshot = await _firestore
          .collection('decks')
          .where('userID', isEqualTo: currentUser.uid)
          .get();

      return querySnapshot.docs
          .map((doc) => Deck.fromMap(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Erro ao buscar decks: $e');
      rethrow;
    }
  }

  // put
  Future<void> updateDeck(Deck deck) async {
    try {
      await _firestore
          .collection('decks')
          .doc(deck.id)
          .update(deck.toMap());
    } catch (e) {
      print('Erro ao atualizar deck: $e');
      rethrow;
    }
  }

  // Delete
  Future<void> deleteDeck(String deckId) async {
    try {
      await _firestore.collection('decks').doc(deckId).delete();
    } catch (e) {
      print('Erro ao deletar deck: $e');
      rethrow;
    }
  }
}