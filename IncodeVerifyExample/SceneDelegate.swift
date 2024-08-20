//
//  SceneDelegate.swift
//  IncodeVerifyExample
//
//  Created by Ivan Nedeljkovic on 6.8.24..
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    guard let _ = (scene as? UIWindowScene) else { return }
  }

  func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
          let url = userActivity.webpageURL else {
      return
    }
    
    // Handle the URL accordingly
    handleUniversalLink(url)
  }

  func handleUniversalLink(_ url: URL) {
    if url.lastPathComponent.contains("verificationResult") {
      var parameters: [String: String] = [:]
      URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach({
        parameters[$0.name] = $0.value
      })

      UserDefaults.standard.setValue(parameters, forKey: "verificationResult")
      NotificationCenter.default.post(name: .didReceiveUniversalLink, object: nil)
    }
  }
}
