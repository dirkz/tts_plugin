// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:async';

import 'dart:developer';

import 'dart:html' as html show window;

import 'dart:js' as js;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'tts_plugin_platform_interface.dart';

/// A web implementation of the TtsPluginPlatform of the TtsPlugin plugin.
class TtsPluginWeb extends TtsPluginPlatform {
  /// Constructs a TtsPluginWeb
  TtsPluginWeb() {
    _synth = js.JsObject.fromBrowserObject(
        js.context["speechSynthesis"] as js.JsObject);
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
    List<Voice> toVoiceList(obj) {
      final voices = <Voice>[];
      for (var jsVoice in obj) {
        final language = jsVoice['lang'];
        final name = jsVoice['name'];
        final url = jsVoice['voiceURI'];
        if (language != null && url != null && name != null) {
          final voice = Voice(language: language, voiceURL: url, name: name);
          _voiceMap[voice] = jsVoice;
          voices.add(voice);
        } else {
          log('*** strange voice $jsVoice');
        }
      }
      return voices;
    }

    final voicesComplete = Completer<List<Voice>>();
    
    voicesHandler(event) {
      final tmpVoices = toVoiceList(_synth.callMethod("getVoices"));
      voicesComplete.complete(tmpVoices);
    }

    final jsVoicesHandler = js.allowInterop(voicesHandler);
    _synth['onvoiceschanged'] = jsVoicesHandler;

    final tmpVoices = toVoiceList(_synth.callMethod("getVoices"));
    if (tmpVoices.isNotEmpty) {
      voicesComplete.complete(tmpVoices);
    }

    return voicesComplete.future;
  }

  @override
  Future<bool> setVoice(Voice voice) {
    _voice = voice;
    return Future.value(true);
  }

  @override
  Future<bool> speak(String text) {
    final jsVoice = _voiceMap[_voice];
    if (jsVoice != null) {
      final jsUtterance = js.JsObject(
          js.context["SpeechSynthesisUtterance"] as js.JsFunction, [""]);
      jsUtterance['voice'] = jsVoice;
      jsUtterance['text'] = text;
      _synth.callMethod('speak', [jsUtterance]);
      return Future.value(true);
    }

    return Future.value(false);
  }

  @override
  Future<bool> cancel() {
    _synth.callMethod('cancel', []);
    return Future.value(true);
  }

  late js.JsObject _synth;
  Voice? _voice;
  final _voiceMap = <Voice, js.JsObject>{};
}
