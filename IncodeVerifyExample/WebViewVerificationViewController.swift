//
//  WebViewVerificationViewController.swift
//  IncodeVerifyExample
//
//  Created by Ivan Nedeljkovic on 13.8.24..
//

import UIKit
import WebKit

class WebViewVerificationViewController: UIViewController {
  
  @IBOutlet weak private var webView: WKWebView!

  private var webViewURLObserver: NSKeyValueObservation?
  private let validUrls = ["incode.id", "incode.com", "incodesmile.com", "incodetest.com"]

  override func viewDidLoad() {
    super.viewDidLoad()
    
    webView.navigationDelegate = self
    webView.uiDelegate = self
    loadRequest()
  
  }

  func loadRequest() {
    if let myURL = URL(string: Constants.verificationURL) {
      let myRequest = URLRequest(url: myURL)
      if myURL.checkParameterForValue(parameter: "enableWebViewInspection", value: "1") {
        if #available(iOS 16.4, *) {
          webView.isInspectable = true
        }
      }
      webView.load(myRequest)
    }
  }

  func addObservers() {
    webViewURLObserver = webView.observe( \.url, options: .new, changeHandler: { [weak self] _, change in
      guard let url = change.newValue as? URL, let self = self else {
        return
      }
      self.handleRedirectIfNeeded(url: url)
    })
  }

  func handleRedirectIfNeeded(url: URL) {
    if url.lastPathComponent.contains("verification-result") {
      var parameters: [String: String] = [:]
      URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach({
        parameters[$0.name] = $0.value
      })

      var queryItems: [URLQueryItem] = []
      if parameters["error"] != nil { queryItems.append(URLQueryItem(name: "error", value: parameters["error"])) }
      if parameters["token"] != nil { queryItems.append(URLQueryItem(name: "token", value: parameters["token"])) }
      if parameters["correlation_id"] != nil { queryItems.append(URLQueryItem(name: "correlation_id", value: parameters["correlation_id"])) }

      guard let redirectURL = parameters["redirect_url"],
            let decodedRedirectURL = URL(string: redirectURL.decodeURL()),
            let deepLink = decodedRedirectURL.appendQueryParams(queryItems: queryItems) else {
        showAlert(title: "Error", message: "Flow completed with no redirect")
        return
      }

      if UIApplication.shared.canOpenURL(deepLink) {
        UIApplication.shared.open(deepLink)
      } else {
        showAlert(title: "Error", message: "Invalid redirect")
      }
    }
  }
}

extension WebViewVerificationViewController: WKUIDelegate, WKNavigationDelegate {
  func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
    completionHandler(.useCredential, cred)
  }

  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    var host = navigationAction.request.url?.host
    host = (host == nil) ? navigationAction.request.mainDocumentURL?.host : host  // permit web app requests
    if let requestHost = host {
      if validUrls.first(where: { requestHost.hasSuffix($0) }) != nil { // allows *.incode.com etc
          decisionHandler(.allow)
          return
      }
    }

    decisionHandler(.cancel)
  }

  @available(iOS 15.0, *)
  func webView(_ webView: WKWebView,
               decideMediaCapturePermissionsFor origin: WKSecurityOrigin,
               initiatedBy frame: WKFrameInfo,
               type: WKMediaCaptureType) async -> WKPermissionDecision {
    return .grant
  }
}

extension UIViewController {
  func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}

extension String {

  func decodeURL() -> String {
    return self.removingPercentEncoding ?? ""
  }
}

extension URL {
  func appendQueryParams(queryItems: [URLQueryItem]) -> URL? {
    guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
      return nil
    }
    urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
    return urlComponents.url
  }

  func checkParameterForValue(parameter: String, value: String) -> Bool {
    guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
      return false
    }

    if let queryItems = components.queryItems {
      return queryItems.contains { $0.name == parameter && $0.value == value }
    }

    return false
  }
}
