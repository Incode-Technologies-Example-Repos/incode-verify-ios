//
//  SceneDelegate.swift
//  IncodeVerifyExample
//
//  Created by Ivan Nedeljkovic on 6.8.24..
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var universalLinkURL: URL?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // This is called when app is not already running.
    if let userActivity = connectionOptions.userActivities.first,
       userActivity.activityType == NSUserActivityTypeBrowsingWeb { //from universal link
      universalLinkURL = userActivity.webpageURL
      handleUniversalLink(universalLinkURL!, scene: scene)
      return
    }
  }

//universal link, app already running
  func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
          let url = userActivity.webpageURL else {
      return
    }
    handleUniversalLink(url, scene: scene)
  }

  //deeplink
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let urlContext = URLContexts.first {
      let url = urlContext.url
     handleUniversalLink(url, scene: scene)
    }
  }

  func handleUniversalLink(_ url: URL, scene: UIScene) {
    if url.lastPathComponent.contains("verificationResult") {
      var parameters: [String: String] = [:]
      URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach({
        parameters[$0.name] = $0.value
      })

      UserDefaults.standard.setValue(parameters, forKey: "verificationResult")
      NotificationCenter.default.post(name: .didReceiveUniversalLink, object: nil)
      WebViewRouter.shared.redirect(to: "result", with: parameters)
    }
  }
}
