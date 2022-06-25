import Cocoa
import FlutterMacOS

public class TtsPlugin: NSObject, FlutterPlugin {
    public static let keyHandleName = "handleName"
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
            let voiceDictsRaw = NSSpeechSynthesizer.availableVoices

            var voices = [[String:String]]()
            for voiceHandleName in voiceDictsRaw {
                let attrs = NSSpeechSynthesizer.attributes(forVoice: voiceHandleName)

                guard let voiceName = attrs[NSSpeechSynthesizer.VoiceAttributeKey.name] as? String else {
                    result(FlutterError(code: "NSSpeechSynthesizer.VoiceAttributeKey.name is not a String",
                                        message: "NSSpeechSynthesizer.VoiceAttributeKey.name is not a String",
                                        details: nil))
                    return
                }

                guard let locale = attrs[NSSpeechSynthesizer.VoiceAttributeKey.localeIdentifier] as? String else {
                    result(FlutterError(code: "NSSpeechSynthesizer.VoiceAttributeKey.localeIdentifier is not a String",
                                        message: "NSSpeechSynthesizer.VoiceAttributeKey.localeIdentifier is not a String",
                                        details: nil))
                    return
                }

                let voiceDict: [String:String] = [TtsPlugin.keyName: voiceName,
                                                  TtsPlugin.keyLanguage: locale,
                                                  TtsPlugin.keyHandleName: voiceHandleName.rawValue]
                voices.append(voiceDict)
            }

            result(voices);
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

            guard let voiceName = voice[TtsPlugin.keyName] else {
                result(FlutterError(code: "Voice Name",
                                    message: "Expected a name in the voice dictionary ([String:String])",
                                    details: nil))
                return;
            }

            guard let text = args[1] as? String else {
                result(FlutterError(code: "Text Parameter",
                                    message: "Expected a String as second parameter, for the text to speak",
                                    details: nil))
                return;
            }

            let theVoiceName = NSSpeechSynthesizer.VoiceName(rawValue: voiceName)

            guard let synth = NSSpeechSynthesizer(voice: theVoiceName) else {
                result(FlutterError(code: "Don't have the correct voice name",
                                    message: "Don't have the correct voice name",
                                    details: nil))
                return
            }

            synth.startSpeaking(text)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
