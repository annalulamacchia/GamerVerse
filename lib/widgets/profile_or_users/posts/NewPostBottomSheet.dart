import 'package:flutter/material.dart';
import 'package:gamerverse/models/game_profile.dart';
import 'package:gamerverse/services/Community/post_service.dart';
import 'package:gamerverse/utils/colors.dart'; // Importa il servizio

class NewPostBottomSheet extends StatefulWidget {
  final Function(String description, String gameId) onPostCreated;
  final List<GameProfile> wishlistGames;
  final VoidCallback? onCreated;

  const NewPostBottomSheet({
    super.key,
    required this.onPostCreated,
    required this.wishlistGames,
    required this.onCreated,
  });

  @override
  _NewPostBottomSheetState createState() => _NewPostBottomSheetState();
}

class _NewPostBottomSheetState extends State<NewPostBottomSheet> {
  String? selectedGameId;
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false; // Per gestire lo stato di caricamento

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'New Post',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          // Dropdown menu
          DropdownButtonFormField<String>(
            value: selectedGameId,
            items: widget.wishlistGames.map((GameProfile game) {
              return DropdownMenuItem<String>(
                value: game.gameId,
                child: Text(
                  game.gameName,
                  style: TextStyle(color: Colors.grey[800]),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedGameId = newValue;
              });
            },
            decoration: InputDecoration(
              labelText: 'Game',
              filled: true,
              fillColor: const Color(0xffe6f2ed),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              labelStyle: TextStyle(color: Colors.grey[800]),
            ),
          ),

          const SizedBox(height: 20),

          // Text field for the description
          Theme(
            data: Theme.of(context).copyWith(
              textSelectionTheme: const TextSelectionThemeData(
                  selectionHandleColor: AppColors.mediumGreen,
                  cursorColor: AppColors.mediumGreen,
                  selectionColor: AppColors.mediumGreen),
            ),
            //Text Area
            child: TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Description',
                filled: true,
                fillColor: const Color(0xffe6f2ed),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.mediumGreen),
                ),
                labelStyle: TextStyle(color: Colors.grey[800]),
                hintText: 'Add a description of your post...',
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Submit button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mediumGreen,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
            ),
            onPressed: () async {
              String description = descriptionController.text;

              if (selectedGameId != null && description.isNotEmpty) {
                // Mostra un indicatore di caricamento
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.teal),
                    );
                  },
                );
                // Chiama il servizio per inviare il post
                final result =
                    await PostService.sendPost(description, selectedGameId!);

                // Chiudi l'indicatore di caricamento
                Navigator.of(context).pop();

                // Controlla il risultato
                if (result['success'] == true) {
                  widget.onCreated!();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post created successfully!')),
                  );
                  Navigator.of(context).pop(); // Chiudi il bottom sheet
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Failed to create post: ${result["message"]}')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all fields')),
                );
              }
            },
            child: const Text(
              'Post',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
