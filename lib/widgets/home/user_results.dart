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
              child: CircularProgressIndicator(color: Colors.teal));
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red)),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No users found.'));
        }

        final users = snapshot.data!;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: user['profile_picture'].isNotEmpty
                    ? NetworkImage(user['profile_picture'])
                    : null,
                child: user['profile_picture'].isEmpty
                    ? Icon(Icons.person, color: Colors.grey)
                    : null,
              ),
              title: Text(user['username']),
              subtitle: Text(user['name']),
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
