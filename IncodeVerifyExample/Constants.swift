//
//  Constants.swift
//  IncodeVerifyExample
//
//  Created by Ivan Nedeljkovic on 12.8.24..
//

import Foundation

final class Constants {
  static let clientId = "AcmeSample"
  // Placeholder. For the Safari and App Clip modes, use a domain you own that serves an
  // apple-app-site-association file, and add it to the associated domains entitlement.
  static let redirectURL = "https%3A%2F%2Fverify-sample.invalid/verificationResult/"
  static let environment = "demo.incode.id"
  static let verificationURL =  String(format: "https://%@/?client_id=%@&redirect_url=%@&origin=native", environment, clientId, redirectURL)
  static let verificationNoRedirectURL =  String(format: "https://%@/?client_id=%@&origin=native", environment, clientId)

}
