import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'tts_plugin_method_channel.dart';
import 'tts_plugin_synth.dart';
import 'tts_plugin_voice.dart';

export 'tts_plugin_voice.dart';
export 'tts_plugin_synth.dart';

abstract class TtsPluginPlatform extends PlatformInterface {
  /// Constructs a TtsPluginPlatform.
  TtsPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static TtsPluginPlatform _instance = MethodChannelTtsPlugin();

  /// The default instance of [TtsPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelTtsPlugin].
  static TtsPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TtsPluginPlatform] when
  /// they register themselves.
  static set instance(TtsPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<List<Voice>> getVoices() {
    throw UnimplementedError('getVoices() has not been implemented.');
  }

  Future<Synth> speak({required Voice voice, required String text}) {
    throw UnimplementedError('speak(voice, text) has not been implemented.');
  }
}
