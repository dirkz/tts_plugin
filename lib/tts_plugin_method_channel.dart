import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'tts_plugin_platform_interface.dart';

/// An implementation of [TtsPluginPlatform] that uses method channels.
class MethodChannelTtsPlugin extends TtsPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tts_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<List<Voice>> getVoices() async {
    final voices =
        await methodChannel.invokeMethod<List<Voice>>('getVoices') ?? [];
    return voices;
  }
}
