import 'package:flutter/material.dart';

class LikedTab extends StatelessWidget {
  const LikedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: 2,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              color: Colors.deepPurple[200],
            ),
          );
        });
  }
}
