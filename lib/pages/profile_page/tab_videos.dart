import 'package:flutter/material.dart';

class VideosTab extends StatelessWidget {
  const VideosTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: 5,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              color: Colors.grey[200],
            ),
          );
        });
  }
}
