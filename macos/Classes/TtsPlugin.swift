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
                    result(error("getVoices(): NSSpeechSynthesizer.VoiceAttributeKey.name is not a String"))
                    return
                }

                guard let locale = attrs[NSSpeechSynthesizer.VoiceAttributeKey.localeIdentifier] as? String else {
                    result(error("getVoices(): NSSpeechSynthesizer.VoiceAttributeKey.localeIdentifier is not a String"))
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
                result(error("speak(): Expected a parameter List"))
                return;
            }

            guard let voice = args.first as? [String:String] else {
                result(error("speak(): Expected a voice [String:String] as first parameter"))
                return;
            }

            guard let voiceHandleString = voice[TtsPlugin.keyHandleName] else {
                result(error("speak(): Expected \(TtsPlugin.keyHandleName) in the voice dictionary"))
                return;
            }

            guard let text = args[1] as? String else {
                result(error("speak(): Expected a String as second parameter, for the text to speak"))
                return;
            }

            let theVoiceName = NSSpeechSynthesizer.VoiceName(rawValue: voiceHandleString)

            guard let synth = NSSpeechSynthesizer(voice: theVoiceName) else {
                result(error("speak(): Doesn't look like a correct voice name: \(voiceHandleString)"))
                return
            }

            synth.startSpeaking(text)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func error(_ message: String) -> FlutterError {
        return FlutterError(code: message, message: nil, details: nil)
    }
}
