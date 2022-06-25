import Flutter
import UIKit

public class SwiftTtsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "tts_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftTtsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }

    private static let keyVoiceURL = "voiceURL"
    private static let keyName = "name"
    private static let keyLanguage = "language"

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
