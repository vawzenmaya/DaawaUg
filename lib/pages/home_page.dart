import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:toktok/api_config.dart';
import 'package:video_player/video_player.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:http/http.dart' as http;

class Video {
  final String videoId;
  final String userId;
  final String videoName;
  final String description;
  final String datePosted;
  final String videoUrl;

  Video({
    required this.videoId,
    required this.userId,
    required this.videoName,
    required this.description,
    required this.datePosted,
    required this.videoUrl,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      videoId: json['videoid'],
      userId: json['userid'],
      videoName: json['videoname'],
      description: json['description'],
      datePosted: json['dateposted'],
      videoUrl: json['videourl'],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isForYouSelected = true;
  late Future<List<Video>> futureVideos;

  @override
  void initState() {
    super.initState();
    futureVideos = fetchVideos();
  }

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
      body: FutureBuilder<List<Video>>(
        future: futureVideos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Colors.grey.withOpacity(0.5),
                strokeWidth: 4.0,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No videos found'));
          } else {
            final videos = snapshot.data!;
            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return VideoPlayerWidget(video: videos[index]);
              },
            );
          }
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final Video video;
  const VideoPlayerWidget({super.key, required this.video});

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video.videoUrl)
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
                                    "assets/p1.jpg",
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
                          child: const Icon(Icons.question_answer, size: 30),
                        ),
                        const Text(
                          "573",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Text(
                          "@${widget.video.userId}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 250,
                          child: ExpandableText(
                            "${widget.video.videoName}\n${widget.video.description}\nDate Posted: ${widget.video.datePosted}",
                            style: const TextStyle(
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
                        const SizedBox(
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

Future<List<Video>> fetchVideos() async {
  final response = await http.get(Uri.parse(ApiConfig.fetchVideosUrl));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Video.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load videos');
  }
}
