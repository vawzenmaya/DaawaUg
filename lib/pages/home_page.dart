// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:expandable_text/expandable_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isForYouSelected = true;
  final List<String> videoUrls = [
    'assets/videos/v1.mp4',
    'assets/videos/v2.mp4',
    'assets/videos/v3.mp4',
    'assets/videos/v4.mp4',
    'assets/videos/software.mp4',
    'assets/videos/allah.mp4',
    'assets/videos/ssemakula.mp4',
    'assets/videos/america.mp4',
    'assets/videos/justus.mp4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
              child: Icon(
                Icons.live_tv,
                color: Colors.white,
                size: 40,
              ),
            ),
            GestureDetector(
              onTap: () => {
                setState(() {
                  _isForYouSelected = true;
                })
              },
              child: Text(
                "For you",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: _isForYouSelected ? 18 : 15,
                      color: _isForYouSelected ? Colors.white : Colors.grey,
                      fontWeight: _isForYouSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
              ),
            ),
            Text(
              "  |  ",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 14, color: Colors.grey),
            ),
            GestureDetector(
              onTap: () => {
                setState(() {
                  _isForYouSelected = false;
                })
              },
              child: Text(
                "Following",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: !_isForYouSelected ? 18 : 15,
                      color: !_isForYouSelected ? Colors.white : Colors.grey,
                      fontWeight: !_isForYouSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(30.0, 0, 0, 0),
              child: Icon(
                Icons.search,
                color: Colors.white,
                size: 40,
              ),
            ),
          ],
        ),
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: videoUrls.length,
        itemBuilder: (context, index) {
          return VideoPlayerWidget(videoUrl: videoUrls[index]);
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({super.key, required this.videoUrl});
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            alignment: Alignment.bottomCenter,
            children: [
              GestureDetector(
                onTap: _togglePlayPause,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        const Spacer(),
                        InkWell(
                          onTap: () {},
                          child: Stack(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/images/avatarx.PNG",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12.5, 30, 0, 0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () {},
                          child: const Icon(Icons.favorite, size: 30),
                        ),
                        const Text(
                          "517K",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () {},
                          child: const Icon(Icons.message, size: 30),
                        ),
                        const Text(
                          "20K",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () {},
                          child: const Icon(Icons.bookmark, size: 30),
                        ),
                        const Text(
                          "713",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () {},
                          child: const Icon(Icons.share, size: 30),
                        ),
                        const Text(
                          "570",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () {},
                          child: const Icon(Icons.download, size: 30),
                        ),
                        const Text(
                          "86K",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ],
                ),
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(),
                        Text(
                          "@daawatok",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 5),
                        SizedBox(
                          width: 250,
                          child: ExpandableText(
                            "This is the DaawaTok Uganda Application developed by Mansoor Group of Technologies by three Computer Scientists: Mansoor, Lauren Vawzen and Justus Kays.",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                            expandText: 'Expand',
                            collapseText: 'Minimize',
                            expandOnTextTap: true,
                            collapseOnTextTap: true,
                            maxLines: 3,
                            linkColor: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  )
                ],
              ),
              VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: Colors.greenAccent,
                  backgroundColor: Colors.grey,
                  bufferedColor: Colors.white,
                ),
              ),
            ],
          )
        : const Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: Colors.lightGreenAccent,
                backgroundColor: Colors.greenAccent,
              ),
            ),
          );
  }
}
