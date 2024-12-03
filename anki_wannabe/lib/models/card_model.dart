import 'package:cloud_firestore/cloud_firestore.dart';

class Card {
  String? id;
  String deckId;
  String frontText;
  String backText;
  DateTime? createdAt;

  Card({
    this.id,
    required this.deckId,
    required this.frontText,
    required this.backText,
    this.createdAt
  });

  Map<String, dynamic> toMap() {
    return {
      'deckId': deckId,
      'frontText': frontText,
      'backText': backText,
      'createdAt': createdAt ?? DateTime.now(),
    };
  }

  factory Card.fromMap(Map<String, dynamic> map, String documentId) {
    return Card(
      id: documentId,
      deckId: map['deckId'],
      frontText: map['frontText'],
      backText: map['backText'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}