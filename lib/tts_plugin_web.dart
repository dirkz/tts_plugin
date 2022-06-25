// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window, SpeechSynthesis;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'tts_plugin_platform_interface.dart';

/// A web implementation of the TtsPluginPlatform of the TtsPlugin plugin.
class TtsPluginWeb extends TtsPluginPlatform {
  /// Constructs a TtsPluginWeb
  TtsPluginWeb();

  static void registerWith(Registrar registrar) {
    TtsPluginPlatform.instance = TtsPluginWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return Future.value(version);
  }

  @override
  Future<List<Voice>> getVoices() {
    print('*** getVoices() ${html.window.speechSynthesis?.getVoices()}');
    final htmlVoices = html.window.speechSynthesis?.getVoices() ?? [];
    final voices = <Voice>[];
    for (var htmlVoice in htmlVoices) {
      final language = htmlVoice.lang;
      final url = htmlVoice.voiceUri;
      final name = htmlVoice.name;
      if (language != null && url != null && name != null) {
        final voice = Voice(language: language, voiceURL: url, name: name);
        voices.add(voice);
      } else {
        print('*** strange voice $htmlVoice');
      }
    }
    return Future.value(voices);
  }

  @override
  Future<bool> setVoice(Voice voice) {
    return Future.value(false);
  }

  @override
  Future<bool> speak(String text) {
    return Future.value(false);
  }

  @override
  Future<bool> cancel() {
    return Future.value(false);
  }
}
