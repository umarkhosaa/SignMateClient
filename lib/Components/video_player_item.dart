import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController playerController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))..initialize().then((value) {
      playerController.play();
      playerController.setVolume(3);
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    playerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: VideoPlayer(playerController),
    );
  }
}
