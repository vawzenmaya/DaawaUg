import 'package:flutter/material.dart';
import 'package:toktok/pages/profile_page/tab_videos.dart';
import 'package:toktok/pages/profile_page/tab_favorites.dart';
import 'package:toktok/pages/profile_page/tab_liked.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  bool _isFollowing = false;
  int _followersCount = 70; // Initial followers count

  // Function to toggle follow/unfollow
  void toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
      if (_isFollowing) {
        _followersCount++; // Increase followers count when following
      } else {
        _followersCount--; // Decrease followers count when unfollowing
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Kasule Laurenmaya',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Icon(Icons.person_add, color: Colors.black),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(Icons.menu, color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Profile pic
            Container(
              height: 120,
              width: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                '@vawzen',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: const Column(
                      children: [
                        Text(
                          '3',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Following',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          '$_followersCount',
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Followers',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: const Column(
                      children: [
                        Text(
                          '370',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Likes',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 15.0, 15.0, 15.0),
                    child: GestureDetector(
                      onTap: toggleFollow, // Toggle follow/unfollow on tap
                      child: Container(
                        // ignore: sort_child_properties_last
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            _isFollowing
                                ? '    Unfollow'
                                : '      Follow', // Show "Follow" or "Unfollow" based on state
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 15.0, 30.0, 15.0),
                    child: Container(
                      // ignore: sort_child_properties_last
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('     Message',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 219, 214, 214),
                        border: Border.all(
                            color: const Color.fromARGB(255, 201, 198, 198)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text('Bio here', style: TextStyle(color: Colors.grey[100])),
            // tab controller
            const TabBar(
              tabs: [
                Tab(
                  text: 'Videos',
                ),
                Tab(
                  text: 'Favorites',
                ),
                Tab(
                  text: 'Liked',
                ),
              ],
              labelColor: Colors.black,
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  VideosTab(),
                  FavoritesTab(),
                  LikedTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
