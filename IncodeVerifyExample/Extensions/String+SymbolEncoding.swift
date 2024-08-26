//
//  String+SymbolEncoding.swift
//  IncodeVerifyExample
//
//  Created by David Mendez on 23/08/24.
//

import Foundation

extension String {
  func percentageEncodeQuery() -> String {
    var percentEncoded = self.replacingOccurrences(of: "?", with: "%253F")
    percentEncoded = percentEncoded.replacingOccurrences(of: "=", with: "%253D")
    percentEncoded = percentEncoded.replacingOccurrences(of: "&", with: "%2526")
    return percentEncoded
  }
}
