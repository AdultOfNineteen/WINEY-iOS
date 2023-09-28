//
//  EncodingType.swift
//  Core
//
//  Created by 박혜운 on 2023/09/14.
//

import Foundation

public enum EncodingType {
  case jsonBody
  case queryString
}

extension EncodingType {
  func encode(_ urlRequest: URLRequest, with parameters: [String: Any]?) throws -> URLRequest {
    var urlRequest = urlRequest
    switch self {
    case .jsonBody:
      // JSON으로 본문 인코딩
      if let parameters = parameters {
        let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        urlRequest.httpBody = jsonData
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      }
    case .queryString:
      // 쿼리 문자열로 인코딩
      if let parameters = parameters {
        let queryString = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        if var urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false) {
          urlComponents.query = queryString
          urlRequest.url = urlComponents.url
        }
      }
    }
    return urlRequest
  }
}
