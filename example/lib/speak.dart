import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:tts_plugin/tts_plugin.dart';

class Speak extends StatefulWidget {
  const Speak({Key? key}) : super(key: key);

  @override
  State<Speak> createState() => _SpeakState();
}

class _SpeakState extends State<Speak> {
  @override
  void initState() {
    super.initState();
    _initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Speak'),
            ),
            body: const Text('Speak')));
  }

  _initState() {}
}
