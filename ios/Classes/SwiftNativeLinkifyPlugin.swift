import Flutter
import UIKit

public class SwiftNativeLinkifyPlugin: NSObject, FlutterPlugin {
    let bridge = AppleLinkifyBridge()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "native_linkify", binaryMessenger: registrar.messenger())
        let instance = SwiftNativeLinkifyPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "findLinks") {
            let res = bridge.findLinks(text: call.arguments as! String)
            result(res.map { $0.toDictionary() })
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
