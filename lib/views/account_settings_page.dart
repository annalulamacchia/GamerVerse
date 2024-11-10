import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';
class AccountSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff051f20), // Sfondo scuro
      appBar: AppBar(
        title: const Text('Username', style: TextStyle(color: Colors.white)), // Placeholder per il nome utente
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xff163832), // Colore per l'AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Immagine profilo e campi Nome/Username
            Row(
              children: [
                Stack(
                  alignment: Alignment.bottomRight, // Posiziona la matita nell'angolo in basso a destra
                  children: [
                    // CircleAvatar come bottone
                    GestureDetector(
                      onTap: () {
                        // Logica per cambiare immagine profilo
                      },
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[800],
                        child: const Icon(Icons.person, size: 40, color: Colors.white70), // Placeholder per l'immagine
                      ),
                    ),

                    // Icona matita per modifica
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 12, // Piccolo cerchio per la matita
                        backgroundColor: Colors.blue, // Colore di sfondo per il cerchio della matita
                        child: const Icon(
                          Icons.edit,
                          size: 14,
                          color: Colors.white, // Colore della matita
                        ),
                      ),
                    ),
                  ],
                ),


                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Titolo "Modify Account"
            const Text(
              'Modify Account',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),

            // Campi Email e Password
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Old Password',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              obscureText: true,
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'New Password',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              obscureText: true,
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Repeat Password',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              obscureText: true,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),

            // Pulsanti di conferma e annullamento
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, size: 40, color: Colors.red),
                  onPressed: () {
                    // Logica per annullare le modifiche
                  },
                ),
                const SizedBox(width: 40),
                IconButton(
                  icon: const Icon(Icons.check, size: 40, color: Colors.green),
                  onPressed: () {
                    // Logica per salvare le modifiche
                  },
                ),
              ],
            ),
            const Spacer(),

            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20.0), // Margine sopra e sotto il pulsante
                child: ElevatedButton(
                  onPressed: () {
                    // Logica per il logout
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    backgroundColor: const Color(0xff3e6259), // Verde scuro per logout
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Logout', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),

            // Pulsante Delete Account
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Logica per eliminare l'account
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700], // Rosso più intenso per delete
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text('Delete Account', style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 10),

            // Pulsante Logout

          ],
        ),
      ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: 2,
          isLoggedIn: true,
        ),

    );
  }
}
