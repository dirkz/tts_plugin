import 'package:flutter_test/flutter_test.dart';
import 'package:tts_plugin/tts_plugin.dart';
import 'package:tts_plugin/tts_plugin_platform_interface.dart';
import 'package:tts_plugin/tts_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTtsPluginPlatform
    with MockPlatformInterfaceMixin
    implements TtsPluginPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<List<Voice>> getVoices() => Future.value([_voiceMilena]);

  @override
  Future<bool> setVoice(Voice voice) => Future.value(true);

  @override
  Future<bool> speak(String text) => Future.value(true);
}

void main() {
  final TtsPluginPlatform initialPlatform = TtsPluginPlatform.instance;

  test('$MethodChannelTtsPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTtsPlugin>());
  });

  test('getPlatformVersion', () async {
    TtsPlugin ttsPlugin = TtsPlugin();
    MockTtsPluginPlatform fakePlatform = MockTtsPluginPlatform();
    TtsPluginPlatform.instance = fakePlatform;

    expect(await ttsPlugin.getVoices(), [_voiceMilena]);
  });

  test('getVoices', () async {
    TtsPlugin ttsPlugin = TtsPlugin();
    MockTtsPluginPlatform fakePlatform = MockTtsPluginPlatform();
    TtsPluginPlatform.instance = fakePlatform;

    expect(await ttsPlugin.getVoices(), [_voiceMilena]);
  });

  test('speak', () async {
    TtsPlugin ttsPlugin = TtsPlugin();
    MockTtsPluginPlatform fakePlatform = MockTtsPluginPlatform();
    TtsPluginPlatform.instance = fakePlatform;

    expect(await ttsPlugin.setVoice(_voiceMilena), true);
    await ttsPlugin.speak("some text");
  });
}

final _voiceMilena =
    Voice(voiceURL: "some_url", language: "ru-RU", name: "Milena");
