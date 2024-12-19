import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gamerverse/services/Community/advised_user_service.dart'; // Importa il servizio
import 'package:gamerverse/widgets/profile_or_users/info/user_follower_card.dart'; // Aggiungi il widget UserCard
import 'package:shared_preferences/shared_preferences.dart';

class NearbyUsersWidget extends StatefulWidget {
  const NearbyUsersWidget({super.key});

  @override
  _NearbyUsersWidgetState createState() => _NearbyUsersWidgetState();
}

class _NearbyUsersWidgetState extends State<NearbyUsersWidget> {
  bool isLoading = true;
  bool hasPermission = false;
  List<Map<String, dynamic>> nearbyUsers = [];
  List<double> userDistances = [];  // Rinomina la lista delle
  String? currentUserId;

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
      final prefs = await SharedPreferences.getInstance();
      print(result);
      setState(() {
        currentUserId = prefs.getString('user_uid') ?? 'default_user';
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
      return const Center(child: CircularProgressIndicator());
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
              child: const Text('Grant Permission'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800]),  // Bottone con colore verde scuro
            ),
          ],
        ),
      );
    }

    return Scaffold(

      backgroundColor: const Color(0xff051f20), // Sfondo verde scuro

      body: nearbyUsers.isEmpty
          ? const Center(child: Text('No nearby users found', style: TextStyle(color: Colors.white)))
          : ListView.builder(
        itemCount: nearbyUsers.length,
        itemBuilder: (context, index) {
          final user = nearbyUsers[index];
          final distance = userDistances.isNotEmpty ? userDistances[index] : 0.0;

          return Column(
            children: [
              const SizedBox(height: 10),
              UserCard(
                index: user['user_id'], // Assumendo che ogni utente abbia un 'id'
                username: user["username"],
                profilePicture: user["profile_picture"] ?? '', // Se manca la foto, usa una stringa vuota
                distance: distance, // Passa la distanza corretta
                onTap: () {
                  if (user["user_id"] != currentUserId || currentUserId == null) {
                    Navigator.pushNamed(context, '/userProfile',
                        arguments: user["user_id"]);
                  } else {
                    Navigator.pushNamed(context, '/profile',
                        arguments: user["user_id"]);
                  }

                },
                currentUser: currentUserId, // Puoi passare l'ID dell'utente corrente se necessario
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
