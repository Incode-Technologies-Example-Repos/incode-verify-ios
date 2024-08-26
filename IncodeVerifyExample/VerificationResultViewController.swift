//
//  VerificationResultViewController.swift
//  IncodeVerifyExample
//
//  Created by Ivan Nedeljkovic on 19.8.24..
//

import UIKit

class VerificationResultViewController: UIViewController {
  
  @IBOutlet weak var resultMessageLabel: UILabel!
  @IBOutlet weak var icon: UIImageView!
  var wasSuccessful = false

  override func viewDidLoad() {
    if !wasSuccessful {
      setUnsuccessfulState()
    }
  }
  func setUnsuccessfulState() {
    icon.image = UIImage(named: "fail")
    resultMessageLabel.text = "Verification was unsuccsessful"
  }
}
