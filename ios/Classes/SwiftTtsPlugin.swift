import UIKit
import AVFoundation

import Flutter

public class SwiftTtsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "tts_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftTtsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "getVoices":
            let speechVoices = AVSpeechSynthesisVoice.speechVoices()

            var voices = [[String:String]]()
            for speechVoice in speechVoices {
                let voiceDict: [String:String] = [SwiftTtsPlugin.keyName: speechVoice.name,
                                                  SwiftTtsPlugin.keyLanguage: speechVoice.language,
                                                  SwiftTtsPlugin.keyVoiceURL: speechVoice.identifier]
                voices.append(voiceDict)
            }

            result(voices);
        case "setVoice":
            guard let voiceURL = SwiftTtsPlugin.extractVoiceURL(methodName: call.method,
                                                                call: call,
                                                                result: result) else {
                return
            }

            voice = AVSpeechSynthesisVoice(identifier: voiceURL)
            if voice == nil {
                result(false)
            } else {
                result(true)
            }
        case "speak":
            guard let args = call.arguments as? [Any] else {
                result(error("\(call.method): Expected a parameter List"))
                return;
            }

            guard let text = args[0] as? String else {
                result(error("\(call.method): Expected a String as second parameter, for the text to speak"))
                return;
            }

            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = voice

            synthesizer.speak(utterance)

            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private static let keyVoiceURL = "voiceURL"
    private static let keyName = "name"
    private static let keyLanguage = "language"

    private lazy var synthesizer: AVSpeechSynthesizer = {
        AVSpeechSynthesizer()
    }()

    private var voice: AVSpeechSynthesisVoice?

    private func error(_ message: String) -> FlutterError {
        return SwiftTtsPlugin.error(message)
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

        guard let voiceURL = voice[SwiftTtsPlugin.keyVoiceURL] else {
            result(error("\(methodName): Expected \(SwiftTtsPlugin.keyVoiceURL) in the voice dictionary"))
            return nil;
        }

        return voiceURL
    }
}
