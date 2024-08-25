import 'package:toktok/models/user.dart';

class Video {
  final String videoUrl;
  final User postedBy;
  final String caption;
  final String audioName;
  int likes;
  final String comments;
  final String questions;
  int downloads;
  bool liked;

  Video(this.videoUrl, this.postedBy, this.caption, this.audioName, this.likes, this.comments, this.questions, this.downloads, {this.liked = false});

  // Video({
  //   required this.videoUrl,
  //   required this.postedBy,
  //   required this.likes,
  //   required this.questions,
  //   required this.comments,
  //   required this.downloads,
  //   this.liked = false, // Set the initial value of liked to false
  // });

}