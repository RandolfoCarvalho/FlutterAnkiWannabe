class Deck {
  String? id;
  String userID;
  String name;
  String description;
  List<dynamic> cards; // Pode ser ajustado conforme necessidade

  Deck({
    this.id,
    required this.userID,
    required this.name,
    this.description = '',
    this.cards = const [],
  });

  // Conversão de/para Map para facilitar manipulação no Firestore
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'name': name,
      'description': description,
      'cards': cards,
    };
  }

  factory Deck.fromMap(Map<String, dynamic> map, String documentId) {
    return Deck(
      id: documentId,
      userID: map['userID'],
      name: map['name'],
      description: map['description'] ?? '',
      cards: map['cards'] ?? [],
    );
  }
}