import 'tts_plugin_platform_interface.dart';

export 'tts_plugin_voice.dart';

class TtsPlugin {
  Future<String?> getPlatformVersion() {
    return TtsPluginPlatform.instance.getPlatformVersion();
  }

  Future<List<Voice>> getVoices() {
    return TtsPluginPlatform.instance.getVoices();
  }
}