import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spade_lite/Common/routes/app_routes.dart';
import 'package:video_player/video_player.dart';

import '../../../Common/camera_components/sending_image_video.dart';
import '../../../Common/camera_components/video_top_view.dart';

class SendingVideoViewPage extends StatefulWidget {
  final String path;
  final String receiverId;

  const SendingVideoViewPage({
    super.key,
    required this.path,
    required this.receiverId,
  });

  @override
  State<SendingVideoViewPage> createState() => _SendingVideoViewPageState();
}

class _SendingVideoViewPageState extends State<SendingVideoViewPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((value) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  bool isFeed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Visibility(
              visible: _controller.value.isInitialized,
              child: SizedBox(
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
            playPauseButton(),
            const VideoViewTopRowWidget(),
            Positioned(
              bottom: 5,
              right: 0,
              left: 0,
              child: SendingImageVideoBottomRowWidget(
                onSendButtonTaped: () {
                  final returnData = (widget.path, isFeed);
                  pop(context, returnData);
                },
                isFeed: isFeed,
                onStoryChanged: (v) {
                  setState(() {
                    isFeed = v;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Align playPauseButton() {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.black38,
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
