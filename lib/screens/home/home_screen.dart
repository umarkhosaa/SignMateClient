import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  VideoPlayerController? _videoController;
  bool _loading = false;
  final List<String> _ignoredWords = ['is', ',', 'the', 'at', 'on', 'in', 'to']; // Extend as needed
  List<String> videoQueue = []; // Queue to hold videos to be played

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF404040), // Changed background color to #404040
      appBar: AppBar(
        title: const Text('ASL Translator'),
        flexibleSpace: Container(
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
        ),
      ),
      body: Stack(
        children: [
          if (_videoController != null && _videoController!.value.isInitialized)
            Center(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width, // Square aspect ratio
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoController!.value.size?.width ?? 0,
                    height: _videoController!.value.size?.height ?? 0,
                    child: VideoPlayer(_videoController!),
                  ),
                ),
              ),
            ),

          if (_loading)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Type to translate a word...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _searchVideo,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _searchVideo() {
    setState(() {
      _loading = true;
    });

    String sentence = _searchController.text.trim().toLowerCase();
    if (sentence.isNotEmpty) {
      _processSentence(sentence);
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  void _processSentence(String sentence) {
    List<String> tokens = sentence.split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty && !_ignoredWords.contains(word) && !RegExp(r'[^\w\s]').hasMatch(word))
        .toList();

    videoQueue.clear();
    for (var token in tokens) {
      String formattedToken = token[0].toUpperCase() + token.substring(1);
      videoQueue.add(formattedToken);
    }
    _playNextVideo();
  }

  void _playNextVideo() {
    if (videoQueue.isEmpty) {
      setState(() {
        _loading = false; // Processing complete, hide loading
      });
      return;
    }

    String title = videoQueue.removeAt(0);
    final String videoPath = 'assets/repo/ASL/$title.mp4';

    _videoController?.dispose();
    _videoController = VideoPlayerController.asset(videoPath)
      ..initialize().then((_) {
        setState(() {
          _loading = false; // Hide loading indicator when video starts
        });
        _videoController!.play();
        _videoController!.addListener(() {
          if (!_videoController!.value.isPlaying &&
              _videoController!.value.position ==
                  _videoController!.value.duration) {
            _videoController!
                .removeListener(() {}); // Remove the current listener
            _playNextVideo(); // Play next video once the current one finishes
          }
        });
      }).catchError((error) {
        print("Error loading video: $error");
        // If the video for the whole word is not found, split it into letters
        if (title.length > 1) {
// Ensure the title is not already a single letter
          List<String> letters = title.split('').map((letter) =>
              letter.toUpperCase()).toList();
          videoQueue.insertAll(0, letters); // Add letters in correct order
        }
        _playNextVideo(); // Attempt to play the next video (or letter)
      });
  }}