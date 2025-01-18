import 'dart:convert';

class Game {
  final String id;
  final String name;
  final String cover;
  final double criticsRating;

  Game({
    required this.id,
    required this.name,
    required this.cover,
    required this.criticsRating,
  });

  //create the Game model from a JSON result
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'].toString(),
      name: utf8.decode(json['name'].codeUnits),
      cover:
          'https://images.igdb.com/igdb/image/upload/t_cover_big_2x/${json['cover']}.jpg',
      criticsRating: json['aggregated_rating'] != null
          ? (json['aggregated_rating'] * 5) / 100
          : 0.0,
    );
  }
}
