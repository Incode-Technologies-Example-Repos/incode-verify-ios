//
//  WebViewRouter.swift
//  IncodeVerifyExample
//
//  Created by David Mendez on 26/08/24.
//

import UIKit

class WebViewRouter {

  private(set) weak var navigationController: UINavigationController?
  private(set) weak var keyWindow: UIWindow?
  var copiedValue: String?

  static let shared = WebViewRouter()

  enum RoutableView: String {
    case entry
    case webView
    case result
  }

  func redirect(to view: String, with parameters: [String: String]) {
    guard let routableView = RoutableView(rawValue: view) else { return }
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    switch routableView {
    case .entry:
      let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: EntryViewController.self))
      showViewController(viewController)
    case .webView:
      let invocationURL = parameters["url"]?.decodeURL()
      guard let webViewController =  storyboard.instantiateViewController(withIdentifier: String(describing: WebViewVerificationViewController.self)) as? WebViewVerificationViewController else { return }
      webViewController.invocationURL = invocationURL
      showViewController(webViewController)
    case .result:
      let isSuccessful = parameters.contains(where: { item in
        item.key == "token"
      })
      if isSuccessful {
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: VerificationResultViewController.self)) as? VerificationResultViewController else { return }
        showViewController(vc)
      } else {
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: VerificationTryAgainViewController.self)) as? VerificationTryAgainViewController else { return }
        showViewController(vc)
      }
    }
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
    self.keyWindow = keyWindow
    return keyWindow
  }

  func showViewController(_ vc: UIViewController, animated: Bool = true) {
    DispatchQueue.main.async { [weak self] in
      let rootViewController = self?.getKeyWindow()?.rootViewController
      if let navigationController = rootViewController?.navigationController, navigationController.presentingViewController != nil {
        self?.navigationController = navigationController
        navigationController.pushViewController(vc, animated: animated)
      } else {
        guard let rootNavigationController = rootViewController as? UINavigationController else {
          let navigationController = UINavigationController()
          navigationController.modalPresentationStyle = .fullScreen
          navigationController.navigationBar.isHidden = true
          self?.navigationController = navigationController
          navigationController.viewControllers = [vc]
          self?.keyWindow?.rootViewController = navigationController
          return
        }
        self?.navigationController = rootNavigationController
        rootNavigationController.modalPresentationStyle = .fullScreen
        rootNavigationController.navigationBar.isHidden = true
        rootNavigationController.pushViewController(vc, animated: animated)
      }
    }
  }
}
