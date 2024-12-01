import 'package:flutter/material.dart';
import 'package:gamerverse/services/Get_user_info.dart';
import 'package:gamerverse/services/specific_game/get_game_service.dart';
import 'package:hugeicons/hugeicons.dart';

class PostCard extends StatefulWidget {
  final String gameId;
  final String description;
  final int likeCount;
  final int commentCount;
  final String timestamp;
  final String userId; // Aggiunto per l'autore
  final VoidCallback onCommentPressed;
  final VoidCallback onDeletePressed;

  const PostCard({
    super.key,
    required this.gameId,
    required this.description,
    required this.likeCount,
    required this.commentCount,
    required this.onCommentPressed,
    required this.onDeletePressed,
    required this.timestamp,
    required this.userId,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.likeCount ?? 0;
  }

  T normalize<T>(T? value, T defaultValue) => value ?? defaultValue;

  Future<Map> fetchPostDetails() async {
    Map<String, dynamic>? userData;
    Map<String, dynamic>? gameData;
    final Response_user = await UserProfileService.getUserByUid(); // Recupera informazioni utente
    final Response_game = await GameService.getGamebyId(widget.gameId); // Recupera informazioni gioco

    if (Response_user['success']) {
      userData = Response_user['data'];
      // Popola i controller con i dati dell'utente
    }
    if (Response_game['success']) {
      gameData = Response_game['data'];
      // Popola i controller con i dati dell'utente
    }
    return {
      "author": userData?["username"] ?? "Unknown User",
      "gameName": gameData?["name"] ?? "Unknown Game",
      "cover": gameData?["cover"] ?? "",
    };
  }


  @override
  Widget build(BuildContext context) {
    final description = normalize<String>(widget.description, "");
    final timestamp = normalize<String>(widget.timestamp, "");
    final commentCount = normalize<int>(widget.commentCount, 0);


    return FutureBuilder<Map>(
      future: fetchPostDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading game details"));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("No game details available"));
        } else {
          final gameName = snapshot.data!["gameName"]!;
          final cover = snapshot.data!["cover"]!;
          final author = snapshot.data!["author"]!;

          return Stack(
            children: [
              Card(
                color: const Color(0xfff0f9f1),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // RIGA CON IMMAGINE, TITOLO E AUTORE
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Immagine del gioco
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                image: cover.isNotEmpty
                                    ? NetworkImage(cover)
                                    : const AssetImage('assets/images/broken_image.png')
                                as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Titolo e autore
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  gameName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Author: $author",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Pulsante elimina (cestino) nell'angolo in alto a destra
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedDelete02,
                            color: Color(0xFF0D5328),
                            size: 28.0,
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      // DESCRIZIONE
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // SEZIONE LIKE E COMMENTI
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.thumb_up, color: Colors.grey[700]),
                            onPressed: () {
                              setState(() {
                                _likeCount++;
                              });
                            },
                          ),
                          Text(
                            "$_likeCount",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            icon: Icon(Icons.comment, color: Colors.grey[700]),
                            onPressed: widget.onCommentPressed,
                          ),
                          Text(
                            "$commentCount",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );

        }
      },
    );
  }
}
