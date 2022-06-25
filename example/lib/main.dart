import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:tts_plugin/tts_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initPlatformState();
    _initVoiceState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }

  final _ttsPlugin = TtsPlugin();

  String _platformVersion = 'Unknown';
  List<Voice> _voices = [];

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initPlatformState() async {
    print('*** trying platformVersion');
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _ttsPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      print('*** have platformVersion $platformVersion');
      _platformVersion = platformVersion;
    });
  }

  Future<void> _initVoiceState() async {
    print('*** trying voices');
    List<Voice> voices = [];

    try {
      voices = await _ttsPlugin.getVoices();
    } on PlatformException {
      voices = [];
    }

    if (!mounted) return;

    setState(() {
      print('*** have voices $voices');
      _voices = voices;
    });
  }
}
