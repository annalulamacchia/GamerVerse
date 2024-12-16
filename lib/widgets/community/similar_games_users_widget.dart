import 'package:flutter/material.dart';

class SimilarGamesUsersWidget extends StatefulWidget {
  const SimilarGamesUsersWidget({Key? key}) : super(key: key);

  @override
  _SimilarGamesUsersWidgetState createState() => _SimilarGamesUsersWidgetState();
}

class _SimilarGamesUsersWidgetState extends State<SimilarGamesUsersWidget> {
  bool isLoading = true;
  List<Map<String, dynamic>> similarGameUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchSimilarGameUsers();
  }

  Future<void> _fetchSimilarGameUsers() async {
    /*try {
      final users = await fetchSimilarGameUsers(); // Implementa questa API nel backend
      setState(() {
        similarGameUsers = users;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching similar game users: $e');
      setState(() {
        isLoading = false;
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : similarGameUsers.isEmpty
        ? const Center(child: Text('No users with similar games found'))
        : ListView.builder(
      itemCount: similarGameUsers.length,
      itemBuilder: (context, index) {
        final user = similarGameUsers[index];
        return ListTile(
          title: Text(user["username"]),
          subtitle: Text('Common Games: ${user["common_games"]}'),
        );
      },
    );
  }
}
