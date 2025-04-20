class Note {
  final String id;
  final String title;
  final dynamic content; // Pour stocker le contenu Quill Delta
  final List<String> tags;
  final String category;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.category,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
  });

  // Méthode pour convertir en Map (utile pour Firebase/Hive)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'tags': tags,
      'category': category,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Méthode pour créer un Note à partir d'une Map
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      tags: List<String>.from(map['tags']),
      category: map['category'],
      isFavorite: map['isFavorite'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
  DateTime? deletedAt;

  // Méthode pour marquer comme supprimée
  void markAsDeleted() {
    deletedAt = DateTime.now();
  }
}