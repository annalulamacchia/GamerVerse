import 'package:flutter/material.dart';
import '../views/profile/profile_post_page.dart';
import '../views/profile/profile_page.dart';
import '../views/profile/profile_reviews_page.dart';
import '../views/other_user_profile/user_profile_page.dart';
import '../views/other_user_profile/user_post_page.dart';

class TabBarSection extends StatefulWidget {
  final int mode; // Aggiunto parametro `mode` per decidere quale modalità usare
  final int selected;
  const TabBarSection({super.key, required this.mode, required this.selected});

  @override
  _TabBarSectionState createState() => _TabBarSectionState();
}

class _TabBarSectionState extends State<TabBarSection> {
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
            widget.selected == 0 ? Colors.green : Colors.black, // Cambia colore in base alla selezione
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
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()), // Naviga alla pagina del profilo
        );
      } else if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileReviewsPage()), // Naviga alla pagina dei post
        );
      } else if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePostPage()), // Naviga alla pagina dei post
        );
      }
    } else if (widget.mode == 1) {
      // Modalità "other user profile" (Esempio con 3 tab)
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfilePage()), // Naviga alla pagina profilo utente
        );
      } else if (index == 1) {
        // Navigazione alla pagina dei commenti/recensioni
           Navigator.push(
           context,
          MaterialPageRoute(builder: (context) => ProfileReviewsPage()), // Pagina delle recensioni
        );
      } else if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserPostPage()), // Naviga alla pagina dei post utente
        );
      }
    }
  }
}
