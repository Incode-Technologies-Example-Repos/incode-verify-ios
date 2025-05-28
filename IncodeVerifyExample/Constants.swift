//
//  Constants.swift
//  IncodeVerifyExample
//
//  Created by Ivan Nedeljkovic on 12.8.24..
//

import Foundation

final class Constants {
  static let clientId = "AcmeSample"
  static let redirectURL = "https%3A%2F%2Fkijak.nl/verificationResult/"
  // static let correlationId = "123"
  static let environment = "demo.incode.id"
  static let verificationURL =  String(format: "https://%@/?client_id=%@&redirect_url=%@&origin=native", environment, clientId, redirectURL)
  // String(format: "https://%@/?client_id=%@&redirect_url=%@&correlation_id=%@&origin=native", environment, clientId, redirectURL, correlationId)
}
