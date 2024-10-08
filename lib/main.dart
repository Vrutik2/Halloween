import 'dart:async';
import 'dart:math'; // Import to use Random
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halloween Game',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Spooky Halloween Vibes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  double ghostPosition = -100;
  double zombiePosition = -100;
  double pumpkinPosition = 200; // Position of the correct item
  double trapPosition = 400; // Position of the trap
  bool isFound = false;

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();
    startAnimation();
  }

  Future<void> _playBackgroundMusic() async {
    try {
      print("Attempting to load audio from: assets/scary.mp3");
      await _audioPlayer.setSource(AssetSource('assets/scary.mp3'));
      await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the background music
      await _audioPlayer.resume(); // Play the audio
      print("Background music is playing");
    } catch (e) {
      print('Error playing background music: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop(); // Stop the music when disposing
    _audioPlayer.dispose();
    super.dispose();
  }

  void startAnimation() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        ghostPosition += 1;
        zombiePosition += 1;
        pumpkinPosition += 1; // Update pumpkin position
        trapPosition += 1; // Update trap position

        // Reset ghost position
        if (ghostPosition > MediaQuery.of(context).size.width) {
          ghostPosition = -100;
        }

        // Reset zombie position
        if (zombiePosition > MediaQuery.of(context).size.width) {
          zombiePosition = -100;
        }

        // Reset pumpkin position
        if (pumpkinPosition > MediaQuery.of(context).size.width) {
          pumpkinPosition = -100; // Reset to the left of the screen
        }

        // Reset trap position
        if (trapPosition > MediaQuery.of(context).size.width) {
          trapPosition = -100; // Reset to the left of the screen
        }
      });
    });
  }

  void _onTapCorrect() {
    _playSound('assets/success_sound.mp3');
    setState(() {
      isFound = true;
    });
    _showDialog('You Found It!', 'Congratulations! You found the correct item!');
  }

  void _onTapTrap() {
    _playSound('assets/jump_scare.mp3');
    _showDialog('Oops!', 'You hit a trap!');
  }

  Future<void> _playSound(String path) async {
    final player = AudioPlayer();
    await player.setSource(AssetSource(path));
    await player.resume();
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/halloween.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          AnimatedPositioned(
            left: ghostPosition,
            top: 100,
            duration: const Duration(milliseconds: 25),
            child: Image.asset('assets/images/ghost.png', width: 200),
          ),
          AnimatedPositioned(
            left: zombiePosition,
            top: 700,
            duration: const Duration(milliseconds: 25),
            child: Image.asset('assets/images/zombie.png', width: 200),
          ),
          AnimatedPositioned(
            left: pumpkinPosition,
            top: 300,
            duration: const Duration(milliseconds: 25),
            child: GestureDetector(
              onTap: !isFound ? _onTapCorrect : null,
              child: Image.asset('assets/images/pumpkin.png', width: 200),
            ),
          ),
          AnimatedPositioned(
            left: trapPosition,
            top: 500,
            duration: const Duration(milliseconds: 25),
            child: GestureDetector(
              onTap: !isFound ? _onTapTrap : null,
              child: Image.asset('assets/images/trap.png', width: 200),
            ),
          ),
        ],
      ),
    );
  }
}
