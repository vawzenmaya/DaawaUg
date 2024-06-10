import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toktok/models/video.dart';
import 'package:toktok/pages/profile_page/follow_page.dart';
import 'video_service.dart'; // Import the VideoService

class HomeSideBar extends StatefulWidget {
  const HomeSideBar({super.key, required this.video});
  final Video video;

  @override
  State<HomeSideBar> createState() => _HomeSideBarState();
}

class _HomeSideBarState extends State<HomeSideBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late VideoService _videoService;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animationController.repeat();
    _videoService = VideoService(); // Initialize VideoService
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 13, color: Colors.white);
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _profileImageButton(widget.video.postedBy.profileImageUrl),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: _sideBarItem('heart', widget.video.likes.toString(), style, Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: _sideBarItem('question', widget.video.questions, style, Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: _sideBarItem('comment', widget.video.comments, style, Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: _sideBarItem('download', widget.video.downloads.toString(), style, Colors.white),
          ),
          AnimatedBuilder(
            animation: _animationController,
            child: Stack(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/disc.png'),
                )
              ],
            ),
            builder: (context, child) {
              return Transform.rotate(
                angle: 2 * pi * _animationController.value,
                child: child,
              );
            },
          )
        ],
      ),
    );
  }

  Widget _sideBarItem(String iconName, String label, TextStyle style, Color iconColor) {
  Color iconAndTextColor = Colors.grey;

  // Function to handle liking/unliking
  void toggleLike() {
    setState(() {
      if (iconName == 'heart') {
        if (widget.video.liked) {
          widget.video.likes--;
        } else {
          widget.video.likes++;
        }
        widget.video.liked = !widget.video.liked;
      } else if (iconName == 'download') {
        // Downloads always increase
        widget.video.downloads++;
      }
    });
  }

  // Determine heart icon color
  Color heartColor = iconName == 'heart' ? (widget.video.liked ? Colors.red : iconAndTextColor) : iconAndTextColor;

  return GestureDetector(
    onTap: toggleLike, // Toggle like/unlike on tap
    child: Column(
      children: [
        SvgPicture.asset(
          'assets/$iconName.svg',
          color: heartColor, // Use heartColor variable
          height: 30,
          width: 30,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          label,
          style: style,
        ),
      ],
    ),
  );
}

 

  Widget _profileImageButton(String imageUrl) {
  return GestureDetector(
    onTap: () {
      _videoService.pause();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FollowPage()),
      ).then((_) {
        _videoService.play();
      });
    },
    child: Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(25),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: -10,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    ),
  );
}


}
