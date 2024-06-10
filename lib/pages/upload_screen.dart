import 'dart:io';
import 'package:flutter/material.dart';
import 'package:toktok/widgets/global.dart';
import 'package:toktok/widgets/input_text_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:lottie/lottie.dart';

class UploadScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const UploadScreen({super.key, required this.videoFile, required this.videoPath});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late VideoPlayerController _controller;
  TextEditingController audioNameTextEditingController = TextEditingController();
  TextEditingController captionTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.3,
              child: _controller.value.isInitialized
                  ? Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(
              height: 30,
            ),
            // Upload button
            //circular progress bar
            //input fields
            showProgressBar == true
              ? Container(
                child: Lottie.asset(
                  'assets/loading.json',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              )
              : Column(
                children: [
                  // audioName
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: InputTextWidget(
                      textEditingController:audioNameTextEditingController,
                      lableString: "Audio Name",
                      iconData: Icons.music_note_sharp,
                      isObscure: false,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // caption
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: InputTextWidget(
                      textEditingController:captionTextEditingController,
                      lableString: "Caption",
                      iconData: Icons.slideshow_sharp,
                      isObscure: false,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // Upload button
                  Container(
                    width: MediaQuery.of(context).size.width - 38,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: InkWell(
                      onTap: (){},
                      child: const Center(
                        child: Text(
                          "Upload",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                
                const SizedBox(
                    height: 20,
                  ),

                ],
              ),
          ],
        ),
      ),
    );
  }
}
