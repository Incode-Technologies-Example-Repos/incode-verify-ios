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
       userActivity.activityType == NSUserActivityTypeBrowsingWeb {
      universalLinkURL = userActivity.webpageURL
      handleUniversalLink(universalLinkURL!, scene: scene)
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
      redirectToResult(url: url, scene: scene)
    }
  }

  func redirectToResult(url: URL, scene: UIScene) {
    let isSuccessful = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.contains(where: { item in
      item.name == "token"
    })
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let scene = (scene as? UIWindowScene) else { return }
    guard let navController = scene.keyWindow?.rootViewController as? UINavigationController else {
      return
    }
    let vc = storyboard.instantiateViewController(withIdentifier: String(describing: VerificationResultViewController.self)) as! VerificationResultViewController
    vc.wasSuccessful = isSuccessful ?? false
    navController.pushViewController(vc, animated: false)
  }
}
