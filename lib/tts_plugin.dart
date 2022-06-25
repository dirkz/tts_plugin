import 'dart:ffi';

import 'tts_plugin_platform_interface.dart';

export 'tts_plugin_voice.dart';

class TtsPlugin {
  Future<String?> getPlatformVersion() {
    return TtsPluginPlatform.instance.getPlatformVersion();
  }

  Future<List<Voice>> getVoices() {
    return TtsPluginPlatform.instance.getVoices();
  }

  Future<bool> setVoice(Voice voice) {
    return TtsPluginPlatform.instance.setVoice(voice);
  }

  Future<void> speak({required Voice voice, required String text}) {
    return TtsPluginPlatform.instance.speak(voice: voice, text: text);
  }
}
