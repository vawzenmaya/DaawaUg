import 'package:toktok/models/user.dart';
import 'package:toktok/models/video.dart';

User currentUser = User('stackedlist', 'assets/p3.jpg');
User user1 = User('Mansor', 'assets/p1.jpg');
User user2 = User('Lauren', 'assets/p2.jpg');
User user3 = User('Justus', 'assets/p4.jpg');

final List<Video> videos = [
  Video(
      'v1.mp4',
      user1,
      'This is a clone of Tiktok by Lauren! known to a few as Vawzen. All tiktok rights have be reserved and none  has been violated, putting that aside, Am a Genius Computer Scientist',
      'audioName',
      50,
      '3',
      '4',
      8),
  Video('v2.mp4', user2, 'Caption', 'audioName', 5, '6', '1', 1),
  Video('v3.mp4', user3, 'Caption', 'audioName', 17, '2', '9', 5),
];
