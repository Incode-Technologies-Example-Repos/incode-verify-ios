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
    addObservers()
  }

  func loadRequest() {
    if let myURL = URL(string: Constants.verificationURL.decodeURL()) {
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
      WebViewRouter.shared.redirect(to: "result", with: parameters)
    }
  }

  @objc private func handleUniversalLink() {
    
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

extension String {

  func decodeURL() -> String {
    return self.removingPercentEncoding ?? ""
  }
}
