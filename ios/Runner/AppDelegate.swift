import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    registerDiscreetChannel(engineBridge.pluginRegistry)
  }

  /// "Discreet mode" platform channel: switch between the primary app icon and
  /// the neutral `AppIcon-Disguise` alternate icon. iOS cannot rename an app at
  /// runtime, so only the icon changes here (Android also changes the name).
  private func registerDiscreetChannel(_ registry: FlutterPluginRegistry) {
    guard let registrar = registry.registrar(forPlugin: "DiscreetIconChannel") else { return }
    let channel = FlutterMethodChannel(
      name: "com.tideapp.momentum/disguise",
      binaryMessenger: registrar.messenger())

    channel.setMethodCallHandler { call, result in
      guard call.method == "setDiscreet" else {
        result(FlutterMethodNotImplemented)
        return
      }
      let enabled = (call.arguments as? [String: Any])?["enabled"] as? Bool ?? false
      guard UIApplication.shared.supportsAlternateIcons else {
        result(false)
        return
      }
      // nil restores the primary icon; a name selects the alternate.
      let iconName: String? = enabled ? "AppIcon-Disguise" : nil
      UIApplication.shared.setAlternateIconName(iconName) { error in
        if let error = error {
          result(FlutterError(
            code: "ICON_ERROR", message: error.localizedDescription, details: nil))
        } else {
          result(true)
        }
      }
    }
  }
}
