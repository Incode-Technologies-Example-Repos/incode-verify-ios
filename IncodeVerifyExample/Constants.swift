//
//  Constants.swift
//  IncodeVerifyExample
//
//  Created by Ivan Nedeljkovic on 12.8.24..
//

import Foundation

final class Constants {
  static let clientId = "incodeid_product338"
  static let redirectURL = "https%3A%2F%2Fkijak.nl/verificationResult/"
  static let correlationId = "123"
  static let environment = "incode-id-5bdz1clk.stage.incodetest.com"
  static let verificationURL = String(format: "https://%@/?client_id=%@&redirect_url=%@&correlation_id=%@&origin=native",
                          environment, clientId, redirectURL, correlationId)
}
