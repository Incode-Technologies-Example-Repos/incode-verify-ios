//
//  UIViewController+ShowAlert.swift
//  IncodeVerifyExample
//
//  Created by Ivan Nedeljkovic on 19.8.24..
//

import UIKit

extension UIViewController {
  func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}
