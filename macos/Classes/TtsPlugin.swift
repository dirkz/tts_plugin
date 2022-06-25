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
            let voiceDictsRaw = NSSpeechSynthesizer.availableVoices

            var voices = [[String:String]]()
            for voiceHandleName in voiceDictsRaw {
                let attrs = NSSpeechSynthesizer.attributes(forVoice: voiceHandleName)

                guard let voiceName = attrs[NSSpeechSynthesizer.VoiceAttributeKey.name] as? String else {
                    result(error("\(call.method): NSSpeechSynthesizer.VoiceAttributeKey.name is not a String"))
                    return
                }

                guard let locale = attrs[NSSpeechSynthesizer.VoiceAttributeKey.localeIdentifier] as? String else {
                    result(error("\(call.method): NSSpeechSynthesizer.VoiceAttributeKey.localeIdentifier is not a String"))
                    return
                }

                let voiceDict: [String:String] = [TtsPlugin.keyName: voiceName,
                                                  TtsPlugin.keyLanguage: locale,
                                                  TtsPlugin.keyVoiceURL: voiceHandleName.rawValue]
                voices.append(voiceDict)
            }

            result(voices);
        case "setVoice":
            guard let voiceURL = TtsPlugin.extractVoiceURL(methodName: call.method,
                                                           call: call,
                                                           result: result) else {
                return
            }

            let theVoice = NSSpeechSynthesizer.VoiceName(rawValue: voiceURL)
            let success = synthesizer.setVoice(theVoice)
            result(success)
        case "speak":
            guard let args = call.arguments as? [Any] else {
                result(error("\(call.method): Expected a parameter List"))
                return;
            }

            guard let text = args[0] as? String else {
                result(error("\(call.method): Expected a String as second parameter, for the text to speak"))
                return;
            }

            let success = synthesizer.startSpeaking(text)
            result(success)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private static let keyVoiceURL = "voiceURL"
    private static let keyName = "name"
    private static let keyLanguage = "language"

    private lazy var synthesizer: NSSpeechSynthesizer = {
        NSSpeechSynthesizer()
    }()

    private func error(_ message: String) -> FlutterError {
        return TtsPlugin.error(message)
    }

    private static func error(_ message: String) -> FlutterError {
        return FlutterError(code: message, message: nil, details: nil)
    }

    private static func extractVoiceURL(methodName: String,
                                        call: FlutterMethodCall,
                                        result: @escaping FlutterResult) -> String? {
        guard let args = call.arguments as? [Any] else {
            result(error("\(methodName): Expected a parameter List"))
            return nil;
        }

        guard let voice = args.first as? [String:String] else {
            result(error("\(methodName): Expected a voice dictionary as first parameter"))
            return nil;
        }

        guard let voiceURL = voice[TtsPlugin.keyVoiceURL] else {
            result(error("\(methodName): Expected \(TtsPlugin.keyVoiceURL) in the voice dictionary"))
            return nil;
        }

        return voiceURL
    }
}
