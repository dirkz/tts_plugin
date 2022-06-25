import Cocoa
import FlutterMacOS

public class TtsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "tts_plugin", binaryMessenger: registrar.messenger)
    let instance = TtsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
    case "getVoices":
        let voiceDictsRaw = NSSpeechSynthesizer.availableVoices.map { voiceName in
            return NSSpeechSynthesizer.attributes(forVoice: voiceName)
        }
        let voiceDicts = voiceDictsRaw.map { voiceDictRaw in
            ["name": voiceDictRaw[NSSpeechSynthesizer.VoiceAttributeKey.name],
             "language": voiceDictRaw[NSSpeechSynthesizer.VoiceAttributeKey.localeIdentifier]]
        }
        result(voiceDicts);
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
