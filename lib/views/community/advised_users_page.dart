// advised_users_page.dart

import 'package:flutter/material.dart';
import '../../widgets/user_follower_card.dart'; // Importa il widget UserCard
import '../other_user_profile/user_profile_page.dart'; // Importa la pagina del profilo

class AdvisedUsersPage extends StatefulWidget {
  const AdvisedUsersPage({super.key});

  @override
  _AdvisedUsersPageState createState() => _AdvisedUsersPageState();
}

class _AdvisedUsersPageState extends State<AdvisedUsersPage> {
  bool Near_you = true;
  bool Same_game = false;
  bool isLocationEnabled = false; // Variabile per il switch della location

  void _toggleTab(String tab) {
    setState(() {
      if (tab == 'Near_you') {
        Near_you = true;
        Same_game = false;
      } else if (tab == 'Same_game') {
        Near_you = false;
        Same_game = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20), // Sfondo scuro
      appBar: AppBar(
        title: const Text(
          'Advised Users',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff163832), // Verde scuro per l'app bar
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            margin: const EdgeInsets.only(top: 30.0, left: 12.0, right: 12.0),
            decoration: BoxDecoration(
              color: Colors.black, // Sfondo del container
              borderRadius: BorderRadius.circular(40.0), // Bordi arrotondati
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton(context, 'Users Near You', Near_you, 'Near_you'),
                _buildTabButton(context, 'Users with Same Game', Same_game, 'Same_game'),
              ],
            ),
          ),

          // Mostra il switch solo quando "Users Near You" è selezionato
          if (Near_you) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text(
                    'Take the location',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const Spacer(),
                  Switch(
                    value: isLocationEnabled,
                    onChanged: (value) {
                      setState(() {
                        isLocationEnabled = value;
                      });
                    },
                    activeColor: const Color(0xFF14A129),
                  ),
                ],
              ),
            ),
          ],

          // Lista di utenti consigliati
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return UserCard(
                  index: index,
                  onTap: () {
                    // Quando la card viene cliccata, naviga alla pagina del profilo utente
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserProfilePage(),
                      ),
                    );
                  },
                ); // Passa la funzione onTap per ogni card
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String text, bool isActive, String tab) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _toggleTab(tab);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: isActive ? const Color(0xff163832) : Colors.black,
            border: Border(
              bottom: BorderSide(
                color: isActive ? const Color(0xFF14A129) : Colors.transparent,
                width: 3.0,
              ),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
