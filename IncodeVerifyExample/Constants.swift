//
//  Constants.swift
//  IncodeVerifyExample
//
//  Created by Ivan Nedeljkovic on 12.8.24..
//

import Foundation

final class Constants {
  static let clientId = "incodeid_product338"
  static let redirectURL = "incodeVerifyExample:verificationResult"
  static let correlationId = "c_123"
  static let environment = "incode-id-5bdz1clk.stage.incodetest.com"
  static let verificationURL = String(format: "https://%@/?client_id=%@&redirect_url=%@&correlation_id=%@&origin=native&enableWebViewInspection=1",
                          environment, clientId, redirectURL, correlationId)
}
