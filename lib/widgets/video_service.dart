import 'package:video_player/video_player.dart';

class VideoService {
  VideoPlayerController? _controller;

  void setController(VideoPlayerController controller) {
    _controller = controller;
  }

  void pause() {
    _controller?.pause();
  }

  void play() {
    _controller?.play();
  }
}
