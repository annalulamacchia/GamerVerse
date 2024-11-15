// game_time_widget.dart
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class GameTimeWidget extends StatelessWidget {
  const GameTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Hourglass Icon
          const HugeIcon(
            icon: HugeIcons.strokeRoundedLoading01,
            color: Colors.white70,
            size: 45.0,
          ),

          //Avarage Playing Time
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '11 h',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Average Playing Time',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),

          //Add Playing Time
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _showAddTimeModal(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: const CircleBorder(),
                ),
                child: const Text(
                  '+',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
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
  }

  //function to show the modal to add playing time
  void _showAddTimeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        int hours = 0;

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
                  hours = int.tryParse(value) ?? 0;
                },
              ),
              const SizedBox(height: 16),

              //Send Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
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
}
