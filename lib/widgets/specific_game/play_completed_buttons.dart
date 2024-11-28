import 'package:flutter/material.dart';
import 'package:gamerverse/models/game.dart';
import 'package:gamerverse/services/statusGameService.dart';

class PlayCompleteButtons extends StatefulWidget {
  final String? userId;
  final Game? game;
  final ValueNotifier<int> playedCountNotifier;

  const PlayCompleteButtons(
      {super.key, this.userId, this.game, required this.playedCountNotifier});

  @override
  PlayCompleteButtonsState createState() => PlayCompleteButtonsState();
}

class PlayCompleteButtonsState extends State<PlayCompleteButtons> {
  bool isPlayingPressed = false;
  bool isCompletedPressed = false;
  bool isLoading = true;
  int completed = 0;

  @override
  void initState() {
    super.initState();
    if (widget.userId != null) {
      _loadGameStatus();
    }
  }

  //load if the game is in the wishlist of the current user
  Future<void> _loadGameStatus() async {
    final statusGame = await StatusGameService.getGameStatus(
        userId: widget.userId, game: widget.game);
    setState(() {
      if (statusGame?['status'] == 'Playing') {
        isPlayingPressed = true;
        isCompletedPressed = false;
      }
      if (statusGame?['status'] == 'Completed') {
        isPlayingPressed = false;
        isCompletedPressed = true;
      }
      if (statusGame?['number_completed'] != null &&
          statusGame?['number_completed'] > 0) {
        completed = statusGame?['number_completed'];
      }
      if (isPlayingPressed || isCompletedPressed) {}
      if (!isPlayingPressed & !isCompletedPressed) {
        widget.playedCountNotifier.value--;
      }
      isLoading = false;
    });
  }

  //function to alternate playing and completed if completed < 1
  void _onPlayingPressed() {
    setState(() {
      isPlayingPressed = !isPlayingPressed;
      if (isPlayingPressed) {
        StatusGameService.setPlaying(userId: widget.userId, game: widget.game);
      }
      if (!isPlayingPressed) {
        StatusGameService.removePlaying(
            userId: widget.userId, game: widget.game);
      }
      if (isPlayingPressed && completed < 1) {
        isCompletedPressed = false;
      } else if (completed > 1) {
        //if completed > 1 completed is always pressed
        isCompletedPressed = true;
      }
      if (isPlayingPressed && !isCompletedPressed) {
        widget.playedCountNotifier.value++;
      }
      if (!isPlayingPressed && !isCompletedPressed) {
        widget.playedCountNotifier.value--;
      }
    });
  }

  //function to substract a completed time on longPress
  void _zeroCompleted() {
    setState(() {
      completed--;
      isCompletedPressed = true;
      if (completed == 0) {
        isCompletedPressed = false;
      }
      StatusGameService.removeCompleted(
          userId: widget.userId, game: widget.game);
      if (!isPlayingPressed && !isCompletedPressed) {
        widget.playedCountNotifier.value--;
      }
    });
  }

  //function to alternate completed and playing
  void _onCompletedPressed() {
    setState(() {
      if (completed < 1) {
        isCompletedPressed = !isCompletedPressed;
        if (isCompletedPressed) {
          isPlayingPressed = false;
        }
      } else {
        //if completed >=1 both playing and completed can be pressed
        isCompletedPressed = true;
        if (isCompletedPressed) {
          isPlayingPressed = false;
        }
      }
      if (isCompletedPressed) {
        completed++;
        StatusGameService.setCompleted(
            userId: widget.userId, game: widget.game);
      }
      if (isCompletedPressed && !isPlayingPressed && completed <= 1) {
        widget.playedCountNotifier.value++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading && widget.userId != null
        ? Center(
            child: Opacity(
              opacity: 0,
              child: CircularProgressIndicator(),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Playing Button
              Expanded(
                child: ElevatedButton(
                  onPressed: _onPlayingPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isPlayingPressed ? Colors.yellow : Colors.white,
                  ),
                  child: const Text('Playing'),
                ),
              ),
              const SizedBox(width: 14),

              //Completed Button
              Expanded(
                child: ElevatedButton(
                    onPressed: _onCompletedPressed,
                    onLongPress: _zeroCompleted,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCompletedPressed ? Colors.green : Colors.white,
                    ),
                    child: completed >= 2
                        ? Text('Completed x$completed',
                            style: const TextStyle(color: Colors.black54))
                        : const Text('Completed',
                            style: TextStyle(color: Colors.black54))),
              ),
            ],
          );
  }
}
