import 'package:flutter/material.dart';
import 'package:gamerverse/models/game.dart';
import 'package:gamerverse/services/specific_game/playing_time_service.dart';
import 'package:gamerverse/widgets/common_sections/dialog_helper.dart';
import 'package:hugeicons/hugeicons.dart';

class GameTimeWidget extends StatefulWidget {
  final String? userId;
  final Game? game;
  final ValueNotifier<double> averageTimeNotifier;

  const GameTimeWidget(
      {super.key, this.userId, this.game, required this.averageTimeNotifier});

  @override
  GameTimeWidgetState createState() => GameTimeWidgetState();
}

class GameTimeWidgetState extends State<GameTimeWidget> {
  bool isLoading = true;
  final TextEditingController _timeController = TextEditingController();
  bool _isLoadingTime = false;

  @override
  void initState() {
    super.initState();
    widget.averageTimeNotifier.addListener(_getAveragePlayingTime);
    _getAveragePlayingTime();
    _getPlayingTime();
  }

  @override
  void dispose() {
    widget.averageTimeNotifier.removeListener(_getAveragePlayingTime);
    super.dispose();
  }

  //load the average playing time
  Future<void> _getAveragePlayingTime() async {
    if (_isLoadingTime) return;
    _isLoadingTime = true;

    if (!mounted) {
      _isLoadingTime = false;
      return;
    }

    final averagePlayingTime =
        await PlayingTimeService.getAveragePlayingTime(game: widget.game);
    setState(() {
      if (averagePlayingTime != null) {
        widget.averageTimeNotifier.value = averagePlayingTime;
      } else {
        widget.averageTimeNotifier.value = 0;
      }
      isLoading = false;
    });

    _isLoadingTime = false;
  }

  //load the playing time of the current user for a specific game
  Future<void> _getPlayingTime() async {
    final playingTime = await PlayingTimeService.getPlayingTime(
      userId: widget.userId,
      game: widget.game,
    );
    setState(() {
      if (playingTime != null && playingTime != 0) {
        _timeController.text = playingTime.toStringAsFixed(0);
      } else {
        _timeController.text = '';
      }
      isLoading = false;
    });
  }

  //set playing time for a specific game
  Future<void> _sendTime(double hours) async {
    try {
      final success = await PlayingTimeService.setPlayingTime(
        userId: widget.userId,
        game: widget.game,
        playingTime: hours,
      );

      if (success) {
        isLoading = true;
        await _getAveragePlayingTime();
        if (hours == 0) {
          //success modal for removing the playing time
          DialogHelper.showSuccessDialog(
              context, "Playing time removed successfully!");
        } else {
          //success modal for adding the playing time
          DialogHelper.showSuccessDialog(
              context, "Playing time added successfully!");
        }
      } else {
        //error modal if the game is not in a playing or completed status
        DialogHelper.showErrorDialog(context,
            "You are not playing or you don't have completed this game. Please try again.");
      }
    } catch (e) {
      DialogHelper.showErrorDialog(
          context, "An unexpected error occurred: ${e.toString()}");
    }
  }

  //redirect to login if the user is not logged
  void _toLoginForTime(BuildContext context) {
    Navigator.pushNamed(context, '/login');
    isLoading = false;
  }

  //form for adding the playing time
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
              //input field
              TextField(
                controller: _timeController,
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
              //send button
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

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ValueListenableBuilder<double>(
            valueListenable: widget.averageTimeNotifier,
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
                    //Hourglass icon
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedLoading01,
                      color: Colors.white70,
                      size: 45.0,
                    ),

                    //Average playing time
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

                    //Add playing time button
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
