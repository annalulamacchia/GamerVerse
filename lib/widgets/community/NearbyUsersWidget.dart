import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gamerverse/services/Community/advised_user_service.dart'; // Importa il widget UserCard


class NearbyUsersWidget extends StatefulWidget {
  const NearbyUsersWidget({super.key});

  @override
  _NearbyUsersWidgetState createState() => _NearbyUsersWidgetState();
}

class _NearbyUsersWidgetState extends State<NearbyUsersWidget> {
  bool isLoading = true;
  bool hasPermission = false;
  List<Map<String, dynamic>> nearbyUsers = [];

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
      final users = await AdvisedUsersService.fetchUsersByLocation(latitude, longitude);      setState(() {
        nearbyUsers = users;
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
            ),
          ],
        ),
      );
    }

    return nearbyUsers.isEmpty
        ? const Center(child: Text('No nearby users found'))
        : ListView.builder(
      itemCount: nearbyUsers.length,
      itemBuilder: (context, index) {
        final user = nearbyUsers[index];
        return ListTile(
          title: Text(user["username"]),
          subtitle: Text('Distance: ${user["distance_km"]} km'),
        );
      },
    );
  }
}
