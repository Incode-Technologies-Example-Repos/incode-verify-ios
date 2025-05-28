//
//  Constants.swift
//  IncodeVerifyExample
//
//  Created by Ivan Nedeljkovic on 12.8.24..
//

import Foundation

final class Constants {
  static let clientId = "AcmeSample"
  static let tiktokClientId = "verify_tiktok833"
  static let redirectURL = "https%3A%2F%2Fkijak.nl/verificationResult/"
  static let environment = "demo.incode.id"
  static let verificationURL =  String(format: "https://%@/?client_id=%@&redirect_url=%@&origin=native", environment, clientId, redirectURL)
  static let verificationTikTokURL =  String(format: "https://%@/?client_id=%@&redirect_url=%@&origin=native", environment, tiktokClientId, redirectURL)
  static let verificationNoRedirectURL =  String(format: "https://%@/?client_id=%@&origin=native", environment, clientId)

}
