import UIKit
import Flutter
import FirebaseDynamicLinks

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    DynamicLinks.performDiagnostics(completion: nil)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
