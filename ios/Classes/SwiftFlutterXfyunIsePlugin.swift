import Flutter
import UIKit

public class SwiftFlutterXfyunIsePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_xfyun_ise", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterXfyunIsePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
      case "init":
          self.initXFyun(call: call)
      case "setParameter":
          self.setParameter(call: call)
      case "start":
          self.start(call: call)
      case "stop":
          self.stop()
      case "cancel":
          self.cancel()
      case "destroy":
          self.destroy()
      case "resultsParsing":
          self.resultsParsing()
      default:
          return
      }
  }
    
    public func initXFyun(call: FlutterMethodCall) {
        
    }
    
    public func setParameter(call: FlutterMethodCall) {
        
    }
    
    public func start(call: FlutterMethodCall) {
        
    }
    
    public func stop() {
        
    }
    
    public func cancel() {
        
    }
    
    public func destroy() {
        
    }
    
    public func resultsParsing() {
        
    }
}
