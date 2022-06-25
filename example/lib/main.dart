import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:tts_plugin/tts_plugin.dart';

import 'speak.dart';

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
              title: Text(_platformVersion),
            ),
            body: ListView.separated(
                itemCount: _voices.length,
                itemBuilder: (BuildContext context, int index) {
                  final speak =
                      Speak(voice: _voices[index], ttsPlugin: _ttsPlugin);
                  return ListTile(
                    title: Text(
                        "${_voices[index].name} (${_voices[index].language})"),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => speak)),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider())));
  }

  final _ttsPlugin = TtsPlugin();

  String _platformVersion = 'Unknown';
  List<Voice> _voices = [];

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initPlatformState() async {
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
      _platformVersion = platformVersion;
    });
  }

  Future<void> _initVoiceState() async {
    List<Voice> voices = [];

    try {
      voices = await _ttsPlugin.getVoices();
    } on PlatformException {
      voices = [];
    }

    if (!mounted) return;

    setState(() {
      _voices = voices;
    });
  }
}
