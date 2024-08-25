// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toktok/api_config.dart';
import 'package:video_player/video_player.dart';

class VideosTab extends StatefulWidget {
  const VideosTab({super.key});
  @override
  _VideosTabState createState() => _VideosTabState();
}

class _VideosTabState extends State<VideosTab> {
  List<dynamic> videos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final response = await http.post(
      Uri.parse(ApiConfig.fetchUserUploadedVideosUrl),
      body: {'userid': userId},
    );

    if (response.statusCode == 200) {
      setState(() {
        videos = json.decode(response.body);
        isLoading = false;
      });
    } else {
      fetchVideos();
      setState(() {
        isLoading = false;
      });
    }
  }

  void playVideo(String videoUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return VideoPopup(videoUrl: videoUrl);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Lottie.asset(
            'assets/loading.json',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ))
        : GridView.builder(
            itemCount: videos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: GestureDetector(
                  onTap: () {
                    playVideo(videos[index]['videourl']);
                  },
                  child: FutureBuilder<VideoPlayerController>(
                    future: initializeVideoPlayer(videos[index]['videourl']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text(
                            'Failed to load video',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ));
                        }
                        return AspectRatio(
                          aspectRatio: snapshot.data!.value.aspectRatio,
                          child: VideoPlayer(snapshot.data!),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                            child: Lottie.asset(
                          'assets/loading.json',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ));
                      } else {
                        return const Center(
                            child: Text(
                          'Failed to load video',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ));
                      }
                    },
                  ),
                ),
              );
            },
          );
  }

  Future<VideoPlayerController> initializeVideoPlayer(String videoUrl) async {
    VideoPlayerController controller = VideoPlayerController.network(videoUrl);
    try {
      await controller.initialize();
    } catch (e) {
      throw Exception('Failed to load video');
    }
    return controller;
  }
}

class VideoPopup extends StatefulWidget {
  final String videoUrl;

  const VideoPopup({required this.videoUrl, super.key});

  @override
  _VideoPopupState createState() => _VideoPopupState();
}

class _VideoPopupState extends State<VideoPopup> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      }).catchError((error) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: double.maxFinite,
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Center(
                child: _controller.value.hasError
                    ? const Text(
                        'Failed to load video',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      )
                    : Lottie.asset(
                        'assets/loading.json',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
