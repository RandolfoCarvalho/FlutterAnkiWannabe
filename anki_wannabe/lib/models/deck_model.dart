// lib/models/deck.dart
class Deck {
  final String id;
  final String name;
  final String userId;
  final DateTime createdAt;

  Deck({
    required this.id,
    required this.name,
    required this.userId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userId': userId,
      'createdAt': createdAt,
    };
  }
}
