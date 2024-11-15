import 'package:flutter/material.dart';

class PlayCompleteButtons extends StatefulWidget {
  const PlayCompleteButtons({super.key});

  @override
  PlayCompleteButtonsState createState() => PlayCompleteButtonsState();
}

class PlayCompleteButtonsState extends State<PlayCompleteButtons> {
  bool isPlayingPressed = false;
  bool isCompletedPressed = false;
  int completed = 0;

  //function to alternate playing and completed if completed < 1
  void _onPlayingPressed() {
    setState(() {
      isPlayingPressed = !isPlayingPressed;
      if (isPlayingPressed && completed < 1) {
        isCompletedPressed = false;
      } else if (completed > 1) {
        //if completed > 1 completed is always pressed
        isCompletedPressed = true;
      }
    });
  }

  //function to substract a completed time on longPress
  void _zeroCompleted() {
    setState(() {
      completed--;
      isCompletedPressed = true;
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
        //increment the completed times
        completed++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Playing Button
        Expanded(
          child: ElevatedButton(
            onPressed: _onPlayingPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isPlayingPressed ? Colors.yellow : Colors.white,
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
