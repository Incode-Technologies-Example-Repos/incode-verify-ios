//
//  AppDelegate.swift
//  IncodeVerifyExample
//
//  Created by Ivan Nedeljkovic on 6.8.24..
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    return true
  }

  // deeplink
  func application(_ application: UIApplication,
                   open url: URL,
                   options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
    // Determine who sent the URL.
        let sendingAppID = options[.sourceApplication]
        print("source application = \(sendingAppID ?? "Unknown")")
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let resultView = storyboard.instantiateViewController(withIdentifier: String(describing: VerificationResultViewController.self))
    showViewController(resultView)

    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  private func getKeyWindow() -> UIWindow? {
    let windowScenes = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
    let activeScene = windowScenes
      .filter { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive}
    let firstActiveScene = activeScene.first
    let keyWindow: UIWindow?
    if #available(iOS 15.0, *) {
      keyWindow = firstActiveScene?.keyWindow
    } else {
      keyWindow = firstActiveScene?.windows.first(where: \.isKeyWindow)
    }
    return keyWindow
  }

  func showViewController(_ vc: UIViewController, animated: Bool = true) {
    DispatchQueue.main.async { [weak self] in
      let rootViewController = self?.getKeyWindow()?.rootViewController
      if let navigationController = rootViewController?.navigationController, navigationController.presentingViewController != nil {
        navigationController.pushViewController(vc, animated: animated)
      } else {
        guard let rootNavigationController = rootViewController as? UINavigationController else {
          let navigationController = UINavigationController()
          navigationController.modalPresentationStyle = .fullScreen
          navigationController.navigationBar.isHidden = true
          navigationController.viewControllers = [vc]
         // self?.keyWindow?.rootViewController = navigationController
          return
        }
        rootNavigationController.modalPresentationStyle = .fullScreen
        rootNavigationController.navigationBar.isHidden = true
        rootNavigationController.pushViewController(vc, animated: animated)
      }
    }
  }
}

