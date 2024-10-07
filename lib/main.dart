import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halloween',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
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
  double ghostPosition = -100;
  double zombiePosition = -100;

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  void startAnimation() {
    Timer.periodic(const Duration(microseconds: 50), (timer) {
      setState(() {
        ghostPosition += 1;
        zombiePosition += 1;

        if (ghostPosition > MediaQuery.of(context).size.width) {
          ghostPosition = -100;
        }

        if (zombiePosition > MediaQuery.of(context).size.width) {
          zombiePosition = -100;
        }
      });
    });
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
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/halloween.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          AnimatedPositioned(
            left: ghostPosition,
            top: 100,
            duration: const Duration(microseconds: 50),
            child: Image.asset('assets/images/ghost.png', width: 200),
          ),

          AnimatedPositioned(
            left: zombiePosition,
            top: 500,
            duration: const Duration(microseconds: 50),
            child: Image.asset('assets/images/zombie.png', width: 200),
          ),
        ],
      ),
    );
  }
}
