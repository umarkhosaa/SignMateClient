import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class HelpScreen extends StatelessWidget {
  void _loadIntroVideo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
        flexibleSpace: Container(
          padding: const EdgeInsets.only(top: 20.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 192, 203),
                Color.fromARGB(200, 255, 0, 0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/Audiozic logo.png',
              height: 35,
              fit: BoxFit.contain,
            ),
          ),
        ),
        elevation: 3,
        shadowColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'FAQs',
              style: TextStyle(
                fontSize: 30,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 8),
            // FAQs using GF Accordions
            GFAccordion(
              title: 'What is SignMate?',
              content:
              'SignMate is a revolutionary application that facilitates communication between hearing individuals and those with impaired hearing or who are completely deaf.',
            ),
            GFAccordion(
              title: 'Can I create ASL content for my videos using SignMate?',
              content:
              'Absolutely! SignMate offers a unique feature for content creators. Simply provide the script of your video using text or voice, and our software will convert it into ASL. You can then download the video and use it as content, making your videos accessible to a wider audience.',
            ),
            GFAccordion(
              title: 'Are there accessibility features in SignMate?',
              content:
              'SignMate includes accessibility features such as the ability to switch between light and dark modes and adjust the font size of the text, ensuring a user-friendly experience for all.',
            ),
            GFAccordion(
              title: 'How can I reset my password if I forget it?',
              content:
              'SignMate allows users to reset their password easily. Simply navigate to the User Management module, where you can find an option to reset your password in case you forget it.',
            ),
            GFAccordion(
              title: 'Can I share ASL translation videos on social media?',
              content:
              'Absolutely! SignMate has a dedicated ASL Video Sharing module that allows users to download the translation video of the 3D model and share it on various social media platforms.',
            ),

            SizedBox(height: 16),
            Text(
              'Tutorials',
              style: TextStyle(
                fontSize: 30,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 8),
            // GF Card beneath the FAQs
            GestureDetector(
              onTap: () {
                _loadIntroVideo(context);
              },
              child: GFCard(
                content: Text(
                  'Tap this card, if you want to watch a tutorial for using the app',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset('assets/tutorial.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      aspectRatio: 9 / 16, // Set the aspect ratio to 16:9
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Intro Video'),
      ),
      body: Center(
        child: Chewie(controller: _chewieController),
      ),
    );
  }
}
