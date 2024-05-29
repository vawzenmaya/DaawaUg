import 'package:flutter/material.dart';
import 'package:toktok/_mock_data/mock.dart';
import 'package:toktok/widgets/home_side_bar.dart';
import 'package:toktok/widgets/video_detail.dart';
import 'package:toktok/widgets/video_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isFollowingSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Icons.live_tv_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            GestureDetector(
              onTap: () => {
                setState(() {
                  _isFollowingSelected = true;
                })
              },
              child: Text(
                "Following",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: _isFollowingSelected ? 18 : 15,
                    color: _isFollowingSelected ? Colors.white : Colors.grey),
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
                  _isFollowingSelected = false;
                })
              },
              child: Text(
                "For you",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: !_isFollowingSelected ? 18 : 15,
                    color: !_isFollowingSelected ? Colors.white : Colors.grey),
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
        // ignore: avoid_print
        onPageChanged: (int page) => {print("Page Changed to $page")},
        scrollDirection: Axis.vertical,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoTile(
                video: videos[index],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      child: VideoDetail(
                        video: videos[index],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 1.75,
                      child: HomeSideBar(video: videos[index]),
                    ),
                  )
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
