import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({Key? key, required this.videoId}) : super(key: key);
  final String videoId;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late YoutubePlayerController? controller;
  @override
  void initState() {
    play();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    controller!.dispose();
    super.dispose();
  }

  play() {
    controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        controlsVisibleAtStart: false,
        hideThumbnail: false,
        loop: true,
        isLive: false,
        forceHD: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: controller!,
              ),
              builder: (context, player) {
                return player;
              },
            ),
          ),
          Positioned(
            top: 30,
            left: 5,
            child: FloatingActionButton(
              heroTag: "17",
              onPressed: () {
                Navigator.pop(context, true);
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.orangeAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
