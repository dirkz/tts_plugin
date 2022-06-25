// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window, SpeechSynthesisUtterance, SpeechSynthesis;
import 'dart:html';

import 'dart:js' as js;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'tts_plugin_platform_interface.dart';

/// A web implementation of the TtsPluginPlatform of the TtsPlugin plugin.
class TtsPluginWeb extends TtsPluginPlatform {
  /// Constructs a TtsPluginWeb
  TtsPluginWeb() {
        _synth = js.JsObject.fromBrowserObject(js.context["speechSynthesis"] as js.JsObject);
  }

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
    var tmpVoices = _synth.callMethod("getVoices");

    final voices = <Voice>[];
    for (var htmlVoice in tmpVoices) {
      final language = htmlVoice['lang'];
      final name = htmlVoice['name'];
      final url = name;
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
    _voice = voice;
    return Future.value(true);
  }

  @override
  Future<bool> speak(String text) {
    final utterance = html.SpeechSynthesisUtterance(text);
    utterance.voice = _voice as SpeechSynthesisVoice?;
    final speech = _synth as html.SpeechSynthesis?;
    
    if (speech != null) {
      speech.speak(utterance);
      return Future.value(true);
    }
    
    return Future.value(false);
  }

  @override
  Future<bool> cancel() {
    return Future.value(false);
  }

  late js.JsObject _synth;
  Voice? _voice;
}
