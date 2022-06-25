import 'tts_plugin_platform_interface.dart';

class Voice {
  String name;
  String language;

  Voice({required this.name, required this.language});
}

class TtsPlugin {
  Future<String?> getPlatformVersion() {
    return TtsPluginPlatform.instance.getPlatformVersion();
  }
}
