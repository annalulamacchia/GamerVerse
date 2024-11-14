import 'package:flutter/material.dart';
import 'package:gamerverse/widgets/bottom_navbar.dart';
import 'package:gamerverse/widgets/specific_game_list.dart';
import 'package:gamerverse/widgets/specific_game_section.dart';
import 'package:gamerverse/widgets/single_review.dart';
import 'package:gamerverse/views/specific_game/all_reviews.dart';

class SpecificGame extends StatelessWidget {
  const SpecificGame({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> developers = ['Red Team', 'Blue Team', 'Dev3'];

    return Scaffold(
      backgroundColor: const Color(0xff051f20),
      appBar: AppBar(
        backgroundColor: const Color(0xff163832),
        title: const Text('Game Name', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            color: Colors.white,
            onPressed: () {
              // Funzionalità per aggiungere ai preferiti
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    color: Colors.grey[300],
                    height: 200.0,
                    width: double.infinity,
                    child: const Icon(Icons.image, size: 100),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      color: Colors.white,
                      onPressed: () {
                        // Funzionalità per aggiungere ai preferiti
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: const EdgeInsets.all(10.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nome del gioco a sinistra
                  Text(
                    'Name Game',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  // Icona fantasma, punteggio e "Users Rating" a destra
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, size: 24, color: Colors.white),
                          // Icona fantasma
                          SizedBox(width: 4),
                          Text(
                            '4.5', // Punteggio
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Users Rating',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Azione quando si preme "Playing"
                    },
                    child: const Text('Playing'),
                  ),
                ),
                // Spazio tra i bottoni
                const SizedBox(width: 14),
                // Bottone "Completed"
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Azione quando si preme "Completed"
                    },
                    child: const Text('Completed'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 18),
                        // Icona stella
                        SizedBox(width: 4),
                        // Spazio tra icona e testo
                        Text(
                          '5',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                    Text(
                      'Critics Rating',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite, color: Colors.white, size: 18),
                        // Icona stella
                        SizedBox(width: 4),
                        // Spazio tra icona e testo
                        Text(
                          '100',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                    Text(
                      'Liked',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.gamepad, color: Colors.white, size: 18),
                        // Icona stella
                        SizedBox(width: 4),
                        // Spazio tra icona e testo
                        Text(
                          '100',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                    Text('Played',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                  ],
                ),
              ],
            ),
            const Divider(height: 25),
            const SpecificGameSectionWidget(title: 'Series'),
            const SizedBox(height: 10),
            const SpecificGameSectionWidget(title: 'Storyline'),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                // Imposta la direzione di scroll orizzontale
                child: Row(
                  children: List.generate(10, (index) {
                    return Container(
                      width: 200,
                      height: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color:
                            Colors.white,
                        borderRadius: BorderRadius.circular(
                            12), // Aggiungi i bordi arrotondati
                      ),
                      // Margine tra i container
                      child: Center(
                        child: Text(
                          'Item ${index + 1}', // Etichetta per ogni container
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const SingleReview(
              username: "Giocatore1",
              rating: 4.5,
              comment: "Questo gioco è fantastico, mi piace molto!",
              avatarUrl: "https://www.example.com/avatar1.jpg", // Sostituconst isci con un URL valido
              likes: 11,
              dislikes: 11,
            ),
            const SizedBox(height: 2),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReviewPage(),
                      ),
                    );
                  },
                  child: const Text('All Reviews')),
            ),

            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[800], // Fondo scuro per il contrasto
                borderRadius: BorderRadius.circular(12), // Bordi arrotondati
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.hourglass_empty,
                    color: Colors.white70,
                    size: 40,
                  ),
                  // Colonna al centro con il numero di ore di gioco
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '11 h', // Numero delle ore di gioco
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Average Playing Time', // Descrizione sotto le ore
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),

                  // Bottone per aggiungere tempo
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Azione per aggiungere tempo giocato
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // Colore del bottone
                          shape: const CircleBorder(), // Forma circolare
                        ),
                        child: const Text(
                          '+',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Colore del simbolo +
                          ),
                        ),
                      ),
                      const SizedBox(height: 2), // Spazio tra il bottone e il testo
                      const Text(
                        'Add your time',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 5),
            SpecificGameList(title: 'Developers', list: developers),
            const SizedBox(height: 2.5),
            SpecificGameList(title: 'Publisher', list: developers),
            const SizedBox(height: 2.5),
            SpecificGameList(title: 'Genre', list: developers),
            const SizedBox(height: 2.5),
            SpecificGameList(title: 'Platforms', list: developers),
            const SizedBox(height: 2.5),
            SpecificGameList(title: 'Release Date', list: developers),
            const SizedBox(height: 5),

            const Divider(),
            const Text('Suggested Games', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(1),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                // Imposta la direzione di scroll orizzontale
                child: Row(
                  children: List.generate(10, (index) {
                    return Container(
                      width: 150,
                      height: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color:
                        Colors.white,
                        borderRadius: BorderRadius.circular(
                            12), // Aggiungi i bordi arrotondati
                      ),
                      // Margine tra i container
                      child: Center(
                        child: Text(
                          'Item ${index + 1}', // Etichetta per ogni container
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1, // Set to Home index or adjust as needed
        isLoggedIn: false,
      ),
    );
  }
}
