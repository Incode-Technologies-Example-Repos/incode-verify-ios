//
//  VerifyMethodViewController.swift
//  IncodeVerifyExample
//
//  Created by Ivan Nedeljkovic on 12.8.24..
//

import UIKit

class VerifyMethodViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  
  // MARK: - Actions
  @IBAction func verifyWithAppClip() {
    var url: URL? = nil
    if #available(iOS 17, *) {
      url = URL(string: "https://appclip.apple.com/id?p=net.incodeid.incode.Clip&url=\(Constants.verificationURL.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!.percentageEncodeQuery())")!
    } else {
      url = URL(string: "https://app.incode.com/?url=\(Constants.verificationURL.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!.percentageEncodeQuery())")!
    }
    //let hardcodeurl = URL(string: "https://app.incode.com/?url=https%253A%252F%252Fincode-id-5bdz1clk.stage.incodetest.com%252F%253Fclient_id%253Dincodeid_product338%2526redirect_url%253Dhttps%253A%252F%252Fkijak.nl/verificationResult/%2526correlation_id%253D123%2526origin%253Dnative")!

    if let url = url, UIApplication.shared.canOpenURL(url) {
      // universal link
      UIApplication.shared.open(url,options: [:])
    } else {
      // show error
      print("can't open url: \(String(describing: url))")
    }
  }

  @IBAction func verifyWithWebView(_ sender: Any) {
    WebViewRouter.shared.redirect(to: "webView", with: [:])
  }

}
