// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok/api_config.dart';
import 'package:toktok/pages/profile_page/follow_page.dart';
import 'package:toktok/pages/profile_page/profile_page.dart';
import 'package:toktok/pages/search_page.dart';
import 'package:video_player/video_player.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

class Video {
  late final String videoId;
  final String userId;
  final String videoName;
  final String videoTitle;
  final String description;
  final String datePosted;
  final String videoUrl;
  final String userName;
  final String fullNames;
  final String profilePicUrl;
  final String role;
  int likeCount;
  int favoriteCount;
  int commentCount;

  Video({
    required this.videoId,
    required this.userId,
    required this.videoName,
    required this.videoTitle,
    required this.description,
    required this.datePosted,
    required this.videoUrl,
    required this.userName,
    required this.fullNames,
    required this.profilePicUrl,
    required this.role,
    required this.likeCount,
    required this.favoriteCount,
    required this.commentCount,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      videoId: json['videoid'],
      userId: json['userid'],
      videoName: json['videoname'],
      videoTitle: json['videotitle'],
      description: json['description'],
      datePosted: json['dateposted'],
      videoUrl: json['videourl'],
      userName: json['username'],
      fullNames: json['fullNames'],
      profilePicUrl: json['profilePic'],
      role: json['role'],
      likeCount: json['likeCount'] != null ? int.parse(json['likeCount']) : 0,
      favoriteCount:
          json['favoriteCount'] != null ? int.parse(json['favoriteCount']) : 0,
      commentCount:
          json['commentCount'] != null ? int.parse(json['commentCount']) : 0,
    );
  }
}

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

final VideoService videoService = VideoService();

class Comment {
  final int commentId;
  final int userId;
  final int videoId;
  final String comment;
  final String dateCommented;
  final String username;
  final String fullNames;
  final String profilePic;
  final String role;

  Comment({
    required this.commentId,
    required this.userId,
    required this.videoId,
    required this.comment,
    required this.dateCommented,
    required this.username,
    required this.fullNames,
    required this.profilePic,
    required this.role,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentid'],
      userId: json['userid'],
      videoId: json['videoid'],
      comment: json['comment'],
      dateCommented: json['datecommented'],
      username: json['username'],
      fullNames: json['fullNames'],
      profilePic: json['profilePic'],
      role: json['role'],
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

  final CacheManager cacheManager = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(days: 1),
      maxNrOfCacheObjects: 20,
    ),
  );

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
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.live_tv,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
                  "Trending",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: !_isForYouSelected ? 18 : 15,
                        color: !_isForYouSelected ? Colors.white : Colors.grey,
                        fontWeight: !_isForYouSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: IconButton(
                  onPressed: () {
                    videoService.pause();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SearchPage()),
                    );
                  },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ]),
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
                return VideoPlayerWidget(
                  video: videos[index],
                  cacheManager: cacheManager,
                  onVideoEnd: () {
                    preloadNextVideos(videos, index);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  void preloadNextVideos(List<Video> videos, int currentIndex) async {
    for (int i = currentIndex + 1;
        i <= currentIndex + 5 && i < videos.length;
        i++) {
      await cacheManager.downloadFile(videos[i].videoUrl);
    }
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final Video video;
  final CacheManager cacheManager;
  final VoidCallback onVideoEnd;
  const VideoPlayerWidget({
    super.key,
    required this.video,
    required this.cacheManager,
    required this.onVideoEnd,
  });
  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isLiked = false;
  bool _isFavorite = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  String? _userId;

  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('dd-MMM-yyyy');
    return formatter.format(parsedDate);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userID');
  }

  @override
  void initState() {
    super.initState();
    fetchlike();
    fetchfavorite();
    fetchComments();
    _initializeVideoPlayer();
    getUserId().then((userId) {
      setState(() {
        _userId = userId;
      });
    });
  }

  Future<void> _initializeVideoPlayer() async {
    final fileInfo =
        await widget.cacheManager.getFileFromCache(widget.video.videoUrl);

    if (fileInfo != null) {
      _controller = VideoPlayerController.file(fileInfo.file);
    } else {
      final file =
          await widget.cacheManager.getSingleFile(widget.video.videoUrl);
      _controller = VideoPlayerController.file(file);
    }

    _controller?.initialize().then((_) {
      setState(() {});
      _controller!.play();
      _controller!.setLooping(true);
      _controller!.addListener(() {
        if (_controller!.value.position == _controller!.value.duration) {
          widget.onVideoEnd();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd-MMM-yyyy');
    String formattedDatePosted =
        dateFormat.format(DateTime.parse(widget.video.datePosted));

    if (_controller != null && _controller!.value.isInitialized) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: GestureDetector(
                        onTap: _togglePlayPause,
                        child: VideoPlayer(_controller!),
                      ),
                    ),
                  ),
                ),
              ],
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
                    GestureDetector(
                      onTap: () {},
                      child: Stack(
                        children: [
                          if (widget.video.profilePicUrl ==
                              ApiConfig.emptyProfilePicUrl)
                            Container(
                              width: 45,
                              height: 45,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: const ClipOval(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 45,
                                ),
                              ),
                            )
                          else
                            Container(
                              width: 45,
                              height: 45,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  widget.video.profilePicUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 35, 0, 0),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.greenAccent,
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
                    if (_isLiked == false)
                      GestureDetector(
                        onTap: () {
                          sendLike(widget.video.videoId);
                          setState(() {
                            _isLiked = true;
                            widget.video.likeCount = widget.video.likeCount + 1;
                          });
                        },
                        child: const Icon(
                          Icons.favorite,
                          size: 30,
                          color: Colors.grey,
                        ),
                      )
                    else if (_isLiked == true)
                      GestureDetector(
                        onTap: () {
                          deleteLike(widget.video.videoId);
                          setState(() {
                            _isLiked = false;
                            widget.video.likeCount = widget.video.likeCount - 1;
                          });
                        },
                        child: const Icon(
                          Icons.favorite,
                          size: 30,
                          color: Colors.red,
                        ),
                      ),
                    if (widget.video.likeCount > 0)
                      Text(
                        widget.video.likeCount.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      )
                    else
                      const Text(
                        "0",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Comments",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    child: FutureBuilder<List<Comment>>(
                                      future: fetchComments(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child: Lottie.asset(
                                            'assets/loading.json',
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ));
                                        } else if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Error: ${snapshot.error}'));
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return const Center(
                                              child: Text(
                                            'No comments yet\nBe the first to comment',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                            textAlign: TextAlign.center,
                                          ));
                                        } else {
                                          List<Comment> comments =
                                              snapshot.data!;
                                          comments = comments.reversed.toList();
                                          return ListView.builder(
                                            itemCount: comments.length,
                                            itemBuilder: (context, index) {
                                              Comment comment = comments[index];
                                              return Card(
                                                color: Colors.white,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (_userId !=
                                                              comment.userId
                                                                  .toString()) {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        FollowPage(
                                                                  userId: comment
                                                                      .userId
                                                                      .toString(),
                                                                ),
                                                              ),
                                                            );
                                                          } else if (_userId ==
                                                              comment.userId
                                                                  .toString()) {
                                                            Get.to(
                                                                const ProfilePage());
                                                          }
                                                        },
                                                        child: Row(
                                                          children: [
                                                            if (comment
                                                                    .profilePic ==
                                                                ApiConfig
                                                                    .emptyProfilePicUrl)
                                                              Container(
                                                                width: 45,
                                                                height: 45,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Colors
                                                                      .grey,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child:
                                                                    const ClipOval(
                                                                  child: Icon(
                                                                    Icons
                                                                        .person,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 45,
                                                                  ),
                                                                ),
                                                              )
                                                            else
                                                              Container(
                                                                width: 45,
                                                                height: 45,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Colors
                                                                      .transparent,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: ClipOval(
                                                                  child: Image
                                                                      .network(
                                                                    comment
                                                                        .profilePic,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                width: 10),
                                                            if (comment
                                                                    .fullNames ==
                                                                "")
                                                              Text(
                                                                "@${comment.username}",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        16),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              )
                                                            else
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    comment
                                                                        .fullNames,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            16),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 2),
                                                                  if (comment
                                                                          .role ==
                                                                      "admin")
                                                                    const Icon(
                                                                        Icons
                                                                            .verified,
                                                                        color: Colors
                                                                            .yellow,
                                                                        size:
                                                                            14)
                                                                  else if (comment
                                                                          .role ==
                                                                      "channel")
                                                                    const Icon(
                                                                        Icons
                                                                            .verified,
                                                                        color: Colors
                                                                            .blue,
                                                                        size:
                                                                            14)
                                                                ],
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      ExpandableText(
                                                        comment.comment,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                        expandText: 'More',
                                                        collapseText: 'Less',
                                                        expandOnTextTap: true,
                                                        collapseOnTextTap: true,
                                                        maxLines: 4,
                                                        linkColor:
                                                            Colors.blueGrey,
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          if (comment.userId
                                                                  .toString() ==
                                                              _userId)
                                                            GestureDetector(
                                                              onTap: () {
                                                                deleteComment(comment
                                                                    .commentId
                                                                    .toString());
                                                              },
                                                              child: const Text(
                                                                "Delete",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            )
                                                          else
                                                            const Text(""),
                                                          Text(
                                                            formatDate(comment
                                                                .dateCommented),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller: _commentController,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                maxLines: null,
                                                maxLength: 250,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w300),
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Comment',
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.greenAccent,
                                                        width: 1),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please type your comment';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                sendComment(
                                                    widget.video.videoId);
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Icon(
                                                  Icons.send,
                                                  color: Colors.greenAccent,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 2.0,
                            ),
                          ),
                        );
                      },
                      child: const Icon(Icons.message, size: 30),
                    ),
                    if (widget.video.commentCount > 0)
                      Text(
                        widget.video.commentCount.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      )
                    else
                      const Text(
                        "0",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                    const SizedBox(height: 12),
                    if (_isFavorite == false)
                      GestureDetector(
                        onTap: () {
                          sendFavorite(widget.video.videoId);
                          setState(() {
                            _isFavorite = true;
                            widget.video.favoriteCount =
                                widget.video.favoriteCount + 1;
                          });
                        },
                        child: const Icon(
                          Icons.bookmark,
                          size: 30,
                          color: Colors.grey,
                        ),
                      )
                    else if (_isFavorite == true)
                      GestureDetector(
                        onTap: () {
                          deleteFavorite(widget.video.videoId);
                          setState(() {
                            _isFavorite = false;
                            widget.video.favoriteCount =
                                widget.video.favoriteCount - 1;
                          });
                        },
                        child: const Icon(
                          Icons.bookmark,
                          size: 30,
                          color: Colors.yellow,
                        ),
                      ),
                    if (widget.video.favoriteCount > 0)
                      Text(
                        widget.video.favoriteCount.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      )
                    else
                      const Text(
                        "0",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.share,
                        size: 30,
                      ),
                    ),
                    const Text(
                      "Share",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.question_answer,
                        size: 30,
                      ),
                    ),
                    const Text(
                      "53K",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
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
                    Row(
                      children: [
                        if (widget.video.fullNames != "")
                          GestureDetector(
                            onTap: () {
                              if (_userId != widget.video.userId) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FollowPage(
                                      userId: widget.video.userId,
                                    ),
                                  ),
                                );
                              } else if (_userId == widget.video.userId) {
                                Get.to(const ProfilePage());
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  widget.video.fullNames,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: 2),
                                if (widget.video.role == "admin")
                                  const Icon(Icons.verified,
                                      color: Colors.yellow, size: 15)
                                else if (widget.video.role == "channel")
                                  const Icon(Icons.verified,
                                      color: Colors.blue, size: 15)
                              ],
                            ),
                          )
                        else
                          GestureDetector(
                            onTap: () {
                              if (_userId != widget.video.userId) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FollowPage(
                                      userId: widget.video.userId,
                                    ),
                                  ),
                                );
                              } else if (_userId == widget.video.userId) {
                                Get.to(const ProfilePage());
                              }
                            },
                            child: Text(
                              "@${widget.video.userName}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: 250,
                      child: ExpandableText(
                        "${widget.video.videoTitle}\n${widget.video.description}",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                        expandText: 'More',
                        collapseText: 'Less',
                        expandOnTextTap: true,
                        collapseOnTextTap: true,
                        maxLines: 3,
                        linkColor: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 20,
                          child: Marquee(
                            text: widget.video.videoName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            blankSpace: 20.0,
                            velocity: 100.0,
                            pauseAfterRound: const Duration(seconds: 1),
                            startPadding: 10.0,
                            accelerationDuration: const Duration(seconds: 1),
                            accelerationCurve: Curves.linear,
                            decelerationDuration:
                                const Duration(milliseconds: 500),
                            decelerationCurve: Curves.easeOut,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "- $formattedDatePosted",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              )
            ],
          ),
          VideoProgressIndicator(
            _controller!,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: Colors.greenAccent,
              backgroundColor: Colors.grey,
              bufferedColor: Colors.white,
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: SizedBox(
          child: Lottie.asset(
            'assets/loading.json',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  Future<void> sendLike(String videoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    final url = Uri.parse(ApiConfig.likeVideoUrl);
    final response = await http.post(
      url,
      body: {
        'userid': userId,
        'videoid': videoId,
      },
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        setState(() {
          _isLiked = true;
        });
      } else {
        // print('Failed to add like: ${responseData['message']}');
      }
    } else {
      // print('Server error: ${response.statusCode}');
    }
  }

  Future<void> fetchlike() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    final url = Uri.parse(ApiConfig.checkLikesUrl);
    final response = await http.post(
      url,
      body: {
        'userid': userId,
        'videoid': widget.video.videoId,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        setState(() {
          _isLiked = true;
        });
      } else {
        setState(() {
          _isLiked = false;
        });
      }
    } else {
      // print('Server error: ${response.statusCode}');
    }
  }

  Future<void> deleteLike(String videoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    final url = Uri.parse(ApiConfig.deletelikeUrl);
    final response = await http.post(
      url,
      body: {
        'userid': userId,
        'videoid': videoId,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        setState(() {
          _isLiked = false;
        });
      } else {
        // print('Failed to delete like: ${responseData['message']}');
      }
    } else {
      // print('Server error: ${response.statusCode}');
    }
  }

  Future<List<Comment>> fetchComments() async {
    String videoid = widget.video.videoId;
    final response =
        await http.get(Uri.parse(ApiConfig.fetchCommentsUrl(videoid)));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Comment> comments =
          body.map((dynamic item) => Comment.fromJson(item)).toList();
      return comments;
    } else {
      fetchComments();
      throw Exception('Failed to load comments');
    }
  }

  Future<void> sendComment(String videoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    final url = Uri.parse(ApiConfig.sendCommentUrl);
    final response = await http.post(
      url,
      body: {
        'userid': userId,
        'videoid': videoId,
        'comment': _commentController.text,
      },
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        setState(() {
          widget.video.commentCount = widget.video.commentCount + 1;
        });
        _commentController.clear();
        Get.snackbar('Successfully', "Commented on this video");
        Navigator.pop(context);
      } else {
        Get.snackbar('Sorry', "Unknown error happened");
      }
    } else {
      sendComment(videoId);
    }
  }

  Future<void> deleteComment(String commentId) async {
    String videoId = widget.video.videoId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');
    Get.defaultDialog(
      title: 'Delete Comment',
      titleStyle: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      content: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Are you sure you want to delete this comment?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                Get.back(result: false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.greenAccent),
              ),
            ),
            TextButton(
              onPressed: () async {
                Get.back(result: true);
                final url = Uri.parse(ApiConfig.deleteCommentUrl);
                final response = await http.post(
                  url,
                  body: {
                    'userid': userId,
                    'videoid': videoId,
                    'commentid': commentId,
                  },
                );

                if (response.statusCode == 200) {
                  final responseData = json.decode(response.body);
                  if (responseData['success']) {
                    setState(() {
                      widget.video.commentCount = widget.video.commentCount - 1;
                    });
                    Get.snackbar('Success', 'Comment deleted successfully');

                    Navigator.pop(context);
                  } else {
                    Get.snackbar('Error', responseData['message']);
                  }
                } else {
                  Get.snackbar('Error', 'Server error: ${response.statusCode}');
                  deleteComment(commentId);
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> sendFavorite(String videoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    final url = Uri.parse(ApiConfig.favoriteVideoUrl);
    final response = await http.post(
      url,
      body: {
        'userid': userId,
        'videoid': videoId,
      },
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        setState(() {
          _isFavorite = true;
        });
      } else {
        // print('Failed to add like: ${responseData['message']}');
      }
    } else {
      // print('Server error: ${response.statusCode}');
    }
  }

  Future<void> fetchfavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    final url = Uri.parse(ApiConfig.checkFavoritesUrl);
    final response = await http.post(
      url,
      body: {
        'userid': userId,
        'videoid': widget.video.videoId,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        setState(() {
          _isFavorite = true;
        });
      } else {
        setState(() {
          _isFavorite = false;
        });
      }
    } else {
      // print('Server error: ${response.statusCode}');
    }
  }

  Future<void> deleteFavorite(String videoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    final url = Uri.parse(ApiConfig.deleteFavoriteUrl);
    final response = await http.post(
      url,
      body: {
        'userid': userId,
        'videoid': videoId,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        setState(() {
          _isFavorite = false;
        });
      } else {
        // print('Failed to delete like: ${responseData['message']}');
      }
    } else {
      // print('Server error: ${response.statusCode}');
    }
  }
}

Future<List<Video>> fetchVideos() async {
  final response = await http.get(Uri.parse(ApiConfig.fetchVideosUrl));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Video.fromJson(json)).toList();
  } else {
    fetchVideos();
    throw Exception('Failed to load videos');
  }
}
