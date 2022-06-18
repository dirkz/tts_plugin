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
  
    expect(await ttsPlugin.getPlatformVersion(), '42');
  });
}
