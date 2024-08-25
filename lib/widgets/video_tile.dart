import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:toktok/models/video.dart';
import 'package:video_player/video_player.dart';
import 'video_service.dart'; // Import the VideoService

class VideoTile extends StatefulWidget {
  const VideoTile({super.key, required this.video});
  final Video video;

  @override
  // ignore: library_private_types_in_public_api
  _VideoTileState createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  late VideoPlayerController _videoController;
  late Future<void> _initializedVideoPlayer;
  final VideoService _videoService = VideoService(); // Create an instance of VideoService

  @override
  void initState() {
    _videoController = VideoPlayerController.asset('assets/${widget.video.videoUrl}');
    _initializedVideoPlayer = _videoController.initialize();
    _videoController.setLooping(true);
    _videoController.play();
    _videoService.setController(_videoController); // Set controller in VideoService
    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _toggleVideoPlayback();
      },
      child: Container(
        color: Colors.black,
        child: FutureBuilder(
          future: _initializedVideoPlayer,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return VideoPlayer(_videoController);
            } else {
              return Container(
                alignment: Alignment.center,
                child: Lottie.asset(
                  'assets/loading.json',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _toggleVideoPlayback() {
    if (_videoController.value.isPlaying) {
      _videoController.pause();
    } else {
      _videoController.play();
    }
  }
}
