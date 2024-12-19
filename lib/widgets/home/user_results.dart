import 'package:flutter/material.dart';
import 'package:gamerverse/services/searchUsername_service.dart';

class UserResults extends StatefulWidget {
  final String searchQuery;

  const UserResults({super.key, required this.searchQuery});

  @override
  _UserResultsState createState() => _UserResultsState();
}

class _UserResultsState extends State<UserResults> {
  late Future<List<Map<String, dynamic>>> _userResults;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  void didUpdateWidget(UserResults oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _fetchUsers();
    }
  }

  void _fetchUsers() {
    setState(() {
      _userResults = UserSearchService.searchUsers(widget.searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _userResults,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.teal),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'An error occurred: ${snapshot.error}',
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Custom message for no search results
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off, color: Colors.white, size: 50),
                SizedBox(height: 10),
                Text(
                  'No users found for "${widget.searchQuery}".',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          );
        }

        final users = snapshot.data!;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: user['profile_picture'].isNotEmpty
                    ? NetworkImage(user['profile_picture'])
                    : null,
                child: user['profile_picture'].isEmpty
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              ),
              title: Text(
                user['username'],
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              subtitle: Text(
                user['name'],
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              onTap: () {
                // Handle user selection (e.g., navigate to user profile page)
                Navigator.pushNamed(context, '/userProfile',
                    arguments: user['id']);
              },
            );
          },
        );
      },
    );
  }
}
