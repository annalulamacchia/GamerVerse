import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart'; // Importa il widget della bottom navbar

class ReportCommentPage extends StatefulWidget {
  @override
  _ReportCommentPageState createState() => _ReportCommentPageState();
}

class _ReportCommentPageState extends State<ReportCommentPage> {
  // Variabili booleane per memorizzare lo stato dei checkbox
  bool isSpamChecked = false;
  bool isAbuseChecked = false;
  bool isOtherChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reason to Report'),
        backgroundColor: const Color(0xff3e6259), // Colore verde scuro
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              title: const Text('Spam'),
              value: isSpamChecked,
              onChanged: (value) {
                setState(() {
                  isSpamChecked = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Abuse'),
              value: isAbuseChecked,
              onChanged: (value) {
                setState(() {
                  isAbuseChecked = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Other'),
              value: isOtherChecked,
              onChanged: (value) {
                setState(() {
                  isOtherChecked = value ?? false;
                });
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff3e6259),
                ),
                onPressed: () {
                  // Mostra il dialogo di conferma per l'invio del report
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Report'),
                        content: const Text('Are you sure you want to report this comment?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Logica per inviare il report
                              Navigator.of(context).pop(); // Chiude il dialogo
                              Navigator.of(context).pop(); // Torna indietro alla pagina precedente
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Report submitted')),
                              );
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Report'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2, // Imposta l'indice corretto per evidenziare la sezione Report
        isLoggedIn: true, // Sostituisci con lo stato di login reale dell'utente
      ),
    );
  }
}
