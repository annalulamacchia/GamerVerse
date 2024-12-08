import 'package:flutter/material.dart';
import 'package:gamerverse/models/game.dart';
import 'package:hugeicons/hugeicons.dart';

class PlayedButtonToList extends StatelessWidget {
  final Game? game;
  final ValueNotifier<int> playedCountNotifier;
  final int? releaseDate;
  final String? userId;

  const PlayedButtonToList(
      {super.key,
      required this.game,
      required this.playedCountNotifier,
      required this.releaseDate,
      this.userId});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: playedCountNotifier,
      builder: (context, playedCount, child) {
        return InkWell(
          onTap: (releaseDate != null &&
                  releaseDate! * 1000 < DateTime.now().millisecondsSinceEpoch)
              ? () {
                  Navigator.pushNamed(context, '/playedList',
                      arguments: {'game': game, 'userId': userId});
                }
              : null,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedGameController03,
                    color: Colors.white,
                    size: 25.0,
                  ),
                  SizedBox(width: 4),
                  Text(
                    (releaseDate != null &&
                                releaseDate! * 1000 <
                                    DateTime.now().millisecondsSinceEpoch) ||
                            releaseDate == null
                        ? playedCount.toString()
                        : 'N/A',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
              Text(
                'Played',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}
