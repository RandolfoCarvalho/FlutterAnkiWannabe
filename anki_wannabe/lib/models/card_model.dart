class FlashCard {
  final String id;
  final String deckId;
  final String front;
  final String back;
  final String userId;
  final DateTime createdAt;

  FlashCard({
    required this.id,
    required this.deckId,
    required this.front,
    required this.back,
    required this.userId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'deckId': deckId,
      'front': front,
      'back': back,
      'userId': userId,
      'createdAt': createdAt,
    };
  }
}