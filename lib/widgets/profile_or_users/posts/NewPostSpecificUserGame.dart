import 'package:flutter/material.dart';
import 'package:gamerverse/services/Community/post_service.dart';
import 'package:gamerverse/utils/colors.dart'; // Importa il servizio

class NewPostSpecificUserGame extends StatefulWidget {
  final Function(String description, String gameId) onPostCreated;
  final VoidCallback? onCreated;
  final String gameId;

  const NewPostSpecificUserGame({
    super.key,
    required this.onPostCreated,
    required this.onCreated,
    required this.gameId,
  });

  @override
  NewPostSpecificUserGameState createState() => NewPostSpecificUserGameState();
}

class NewPostSpecificUserGameState extends State<NewPostSpecificUserGame> {
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false; // Per gestire lo stato di caricamento

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom:
            MediaQuery.of(context).viewInsets.bottom + 16, // Gestione tastiera
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'New Post',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

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
                fillColor: Colors.white12,
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
                labelStyle: TextStyle(color: Colors.white70),
                hintText: 'Add a description of your post...',
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
              style: TextStyle(color: Colors.white),
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

              if (description.isNotEmpty) {
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
                    await PostService.sendPost(description, widget.gameId);

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
