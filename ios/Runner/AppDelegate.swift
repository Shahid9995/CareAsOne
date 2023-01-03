import UIKit
import Flutter
import Firebase
import FBSDKCoreKit
//import agora_rtc_engine


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    //GMSServices.provideAPIKey("AIzaSyCxoMdHOVPaOHjqhxeyupZJPkPpW-WpEpQ")
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    //RtcEnginePluginRegistrant.register(with:self)
   // FlutterDownloaderPlugin setPluginRegistrantCallback:registerPlugins;
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
