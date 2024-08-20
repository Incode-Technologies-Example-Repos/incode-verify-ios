//
//  URL+QueryParameters.swift
//  IncodeVerifyExample
//
//  Created by Ivan Nedeljkovic on 19.8.24..
//

import Foundation

extension URL {
  func appendQueryParams(queryItems: [URLQueryItem]) -> URL? {
    guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
      return nil
    }
    urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
    return urlComponents.url
  }

  func checkParameterForValue(parameter: String, value: String) -> Bool {
    guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
      return false
    }

    if let queryItems = components.queryItems {
      return queryItems.contains { $0.name == parameter && $0.value == value }
    }

    return false
  }
}
