import 'package:flutter/material.dart';
import 'package:gamerverse/utils/firebase_auth_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabBarSection extends StatefulWidget {
  final int mode; // Aggiunto parametro `mode` per decidere quale modalità usare
  final int selected;

  const TabBarSection({super.key, required this.mode, required this.selected});

  @override
  _TabBarSectionState createState() => _TabBarSectionState();
}

class _TabBarSectionState extends State<TabBarSection> {
  late String? userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  //load the user_id
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uid = prefs.getString('user_uid');
    final valid = await FirebaseAuthHelper.checkTokenValidity();
    setState(() {
      if (valid) {
        userId = uid;
      } else {
        userId = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determina quale indice usare a seconda della modalità
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTabButton(
            context,
            'Games',
            widget.selected == 0 ? Colors.green : Colors.black,
            // Cambia colore in base alla selezione
            () => _onTabSelected(0),
          ),
          _buildTabButton(
            context,
            'Reviews',
            widget.selected == 1 ? Colors.green : Colors.black,
            () => _onTabSelected(1),
          ),
          _buildTabButton(
            context,
            'Post',
            widget.selected == 2 ? Colors.green : Colors.black,
            () => _onTabSelected(2),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
      BuildContext context, String text, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            color: color, // Cambia il colore del bottone
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void _onTabSelected(int index) {
    // Navigazione a seconda della modalità (mode) e della tab selezionata
    if (widget.mode == 0) {
      // Modalità "profile" (Esempio con 3 tab)
      if (index == 0) {
        Navigator.pushNamed(context, '/profile');
      } else if (index == 1) {
        Navigator.pushNamed(context, '/profileReviews', arguments: userId);
      } else if (index == 2) {
        Navigator.pushNamed(context, '/profilePosts');
      }
    } else if (widget.mode == 1) {
      // Modalità "other user profile" (Esempio con 3 tab)
      if (index == 0) {
        Navigator.pushNamed(context, '/userProfile');
      } else if (index == 1) {
        // Navigazione alla pagina dei commenti/recensioni
        Navigator.pushNamed(context, '/profileReviews', arguments: userId);
      } else if (index == 2) {
        Navigator.pushNamed(context, '/userPosts');
      }
    }
  }
}
