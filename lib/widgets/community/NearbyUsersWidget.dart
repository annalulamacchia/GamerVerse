import 'package:flutter/material.dart';
import 'package:gamerverse/utils/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gamerverse/services/community/advised_user_service.dart'; // Importa il servizio
import 'package:gamerverse/widgets/profile_or_users/info/user_follower_card.dart'; // Aggiungi il widget UserCard

class NearbyUsersWidget extends StatefulWidget {
  const NearbyUsersWidget({super.key});

  @override
  _NearbyUsersWidgetState createState() => _NearbyUsersWidgetState();
}

class _NearbyUsersWidgetState extends State<NearbyUsersWidget> {
  bool isLoading = true;
  bool hasPermission = false;
  List<Map<String, dynamic>> nearbyUsers = [];
  List<double> userDistances = [];  // Rinomina la lista delle distanze

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermission();
  }

  Future<void> _checkAndRequestPermission() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      setState(() {
        hasPermission = true;
      });
      _fetchNearbyUsers();
    } else {
      setState(() {
        hasPermission = false;
        isLoading = false;
      });
    }
  }

  Future<void> _fetchNearbyUsers() async {
    try {
      final position = await AdvisedUsersService.getPosition();
      final latitude = position.latitude;
      final longitude = position.longitude;
      print(latitude);
      print(longitude);

      // Assicurati che fetchUsersByLocation ritorni una struttura corretta
      final result = await AdvisedUsersService.fetchUsersByLocation(latitude, longitude);
      print(result);
      setState(() {
        // Verifica se la risposta contiene effettivamente una lista
        nearbyUsers = result["users"] is List
            ? List<Map<String, dynamic>>.from(result["users"] as Iterable)
            : [];
        print(nearbyUsers);
        userDistances = result["distances"] is List
            ? List<double>.from(result["distances"] as Iterable)
            : [];
        print(userDistances);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching nearby users: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.teal));
    }

    if (!hasPermission) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No permission for location',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _checkAndRequestPermission(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800]),
              child: const Text('Grant Permission'),  // Bottone con colore verde scuro
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.darkestGreen, // Sfondo verde scuro
      body: nearbyUsers.isEmpty
          ? const Center(child: Text('No nearby users found', style: TextStyle(color: Colors.white)))
          : ListView.builder(
        itemCount: nearbyUsers.length,
        itemBuilder: (context, index) {
          final user = nearbyUsers[index];
          final distance = userDistances.isNotEmpty ? userDistances[index] : 0.0;  // Gestisci la distanza
          return Column(
            children: [
              const SizedBox(height: 10), // Aggiungi un po' di spazio tra le card
              UserCard(
                index: user['user_id'], // Assumendo che ogni utente abbia un 'id'
                username: user["username"],
                profilePicture: user["profile_picture"] ?? '', // Se manca la foto, usa una stringa vuota
                distance: distance, // Passa la distanza corretta
                onTap: () {
                  // Azione al tap della card (puoi personalizzarla come preferisci)
                  print('Tapped on user: ${user["username"]}');
                },
                currentUser: null, // Puoi passare l'ID dell'utente corrente se necessario
                isFollowed: false, // Passa lo stato di follow (modifica se necessario)
                isBlocked: false, // Passa lo stato di blocco (modifica se necessario)
                parentContext: context,
              ),
            ],
          );
        },
      ),
    );

  }
}
