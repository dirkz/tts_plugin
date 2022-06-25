import 'tts_plugin_platform_interface.dart';

export 'voice.dart';

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

  Future<bool> speak(String text) {
    return TtsPluginPlatform.instance.speak(text);
  }

  Future<bool> cancel() {
    return TtsPluginPlatform.instance.cancel();
  }
}
