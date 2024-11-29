import 'package:flutter/material.dart';
import 'package:gamerverse/models/game.dart';
import 'package:gamerverse/services/specific_game/playingTimeService.dart';
import 'package:hugeicons/hugeicons.dart';

class GameTimeWidget extends StatefulWidget {
  final String? userId;
  final Game? game;

  const GameTimeWidget({super.key, this.userId, this.game});

  @override
  _GameTimeWidgetState createState() => _GameTimeWidgetState();
}

class _GameTimeWidgetState extends State<GameTimeWidget> {
  bool isLoading = true;
  final TextEditingController _timeController = TextEditingController();
  ValueNotifier<double> averageTimeNotifier = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    averageTimeNotifier.addListener(_getAveragePlayingTime);
    _getAveragePlayingTime();
    _getPlayingTime();
  }

  @override
  void dispose() {
    averageTimeNotifier.removeListener(_getAveragePlayingTime);
    super.dispose();
  }

  Future<void> _getAveragePlayingTime() async {
    final averagePlayingTime =
        await PlayingTimeService.getAveragePlayingTime(game: widget.game);
    setState(() {
      if (averagePlayingTime != null) {
        averageTimeNotifier.value = averagePlayingTime;
      } else {
        averageTimeNotifier.value = 0;
      }
      isLoading = false;
    });
  }

  // Funzione per ottenere il tempo giocato dal database
  Future<void> _getPlayingTime() async {
    final playingTime = await PlayingTimeService.getPlayingTime(
      userId: widget.userId,
      game: widget.game,
    );
    setState(() {
      if (playingTime != null) {
        _timeController.text = playingTime
            .toString(); // Imposta il valore delle ore nel campo di input
      } else {
        _timeController.text = ''; // Se non ci sono ore, lascia il campo vuoto
      }
      isLoading = false;
    });
  }

  Future<void> _sendTime(double hours) async {
    try {
      // Logica per inviare il tempo al servizio backend
      final success = await PlayingTimeService.setPlayingTime(
        userId: widget.userId,
        game: widget.game,
        playingTime: hours,
      );

      if (success) {
        await _getAveragePlayingTime();
        if (hours == 0) {
          _showSuccessDialog("Playing time removed successfully!");
        } else {
          _showSuccessDialog("Playing time added successfully!");
        }
      } else {
        _showErrorDialog(
            "You are not playing or you don't have completed this game. Please try again.");
      }
    } catch (e) {
      _showErrorDialog("An unexpected error occurred: ${e.toString()}");
    }
  }

  void _toLoginForTime(BuildContext context) {
    Navigator.pushNamed(context, '/login');
    isLoading = false;
  }

  void _showAddTimeModal(BuildContext context) {
    double hours = 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Hours Played',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _timeController,
                // Assegna il controller al campo di input
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Hours',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                  fillColor: Colors.white12,
                  filled: true,
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  hours = double.tryParse(value) ?? 0;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _sendTime(hours);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff3e6259),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Send',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Error',
          style: TextStyle(color: Colors.red),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ValueListenableBuilder<double>(
            valueListenable: averageTimeNotifier,
            builder: (context, averageTime, child) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icona della clessidra
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedLoading01,
                      color: Colors.white70,
                      size: 45.0,
                    ),

                    // Ore di gioco medie
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$averageTime h',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Total Playing Time',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),

                    // Aggiungi ore
                    Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              widget.userId != null
                                  ? _showAddTimeModal(context)
                                  : _toLoginForTime(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff3e6259),
                              shape: const CircleBorder(),
                            ),
                            child: const Icon(Icons.add,
                                color: Colors.white, size: 25)),
                        const SizedBox(height: 2),
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
              );
            },
          );
  }
}
