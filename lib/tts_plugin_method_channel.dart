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
    // invokeMethod here returns a Future<dynamic> that completes to a
    // List<dynamic> with Map<dynamic, dynamic> entries. Post-processing
    // code thus cannot assume e.g. List<Map<String, String>> even though
    // the actual values involved would support such a typed container.
    // The correct type cannot be inferred with any value of `T`.
    final List<dynamic>? voices =
        await methodChannel.invokeMethod<List<dynamic>>('getVoices');
    return voices?.map(Voice.fromJson).toList() ?? <Voice>[];
  }

  @override
  Future<bool> setVoice(Voice voice) async {
    return await methodChannel.invokeMethod("setVoice", [voice]);
  }

  @override
  Future<bool> speak(String text) async {
    return await methodChannel.invokeMethod("speak", [text]);
  }
}
