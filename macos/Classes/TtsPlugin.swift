import Cocoa
import FlutterMacOS

public class TtsPlugin: NSObject, FlutterPlugin {
    public static let keyName = "name"
    public static let keyLanguage = "language"

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
                [TtsPlugin.keyName: voiceDictRaw[NSSpeechSynthesizer.VoiceAttributeKey.name],
                 TtsPlugin.keyLanguage: voiceDictRaw[NSSpeechSynthesizer.VoiceAttributeKey.localeIdentifier]]
            }
            result(voiceDicts);
        case "speak":
            guard let args = call.arguments as? [Any] else {
                result(FlutterError(code: "Parameter List",
                                    message: "Expected parameters as list",
                                    details: nil))
                return;
            }
            guard let voice = args.first as? [String:String] else {
                result(FlutterError(code: "Voice Parameter",
                                    message: "Expected a voice [String:String] as first parameter",
                                    details: nil))
                return;
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
