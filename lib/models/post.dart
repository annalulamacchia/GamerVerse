class Post {
  final String id; // L'ID del post
  final String writerId; // L'ID dello scrittore del post
  final String gameId; // L'ID del gioco associato al post
  final String description; // La descrizione del post
  final List<String> likedBy; // Lista di utenti che hanno messo like
  final int commentCount; // Numero di commenti
  final String timestamp;
  final String father; // Rappresenta il padre del post (0 se è un post principale)

  Post({
    required this.id,
    required this.writerId,
    required this.gameId,
    required this.description,
    required this.likedBy,
    required this.commentCount,
    required this.timestamp,
    required this.father,
  });

  // Factory per creare un'istanza da una mappa JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['post_id'] ?? '',
      writerId: json['writer_id'] ?? '',
      gameId: json['game_id'] ?? '',
      description: json['description'] ?? '',
      likedBy: List<String>.from(json['liked_by'] ?? []), // Lista di utenti che hanno messo like
      commentCount: json['comment_count'] ?? 0, // Numero di commenti
      father: json['father'] ?? '0',
      timestamp: json['timestamp'] ?? '0',
    );
  }

  // Metodo per convertire un'istanza in una mappa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'writer_id': writerId,
      'game_id': gameId,
      'description': description,
      'liked_by': likedBy,
      'comment_count': commentCount,
      'timestamp': timestamp,
      'father': father,
    };
  }


  // Metodo di utilità per verificare se il post è un commento
  bool isComment() {
    return father != '0';
  }
}
