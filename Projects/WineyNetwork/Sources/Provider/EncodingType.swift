//
//  EncodingType.swift
//  Core
//
//  Created by 박혜운 on 2023/09/14.
//

import Foundation
import UIKit

public enum EncodingType {
  case jsonBody
  case queryString
  case multiPart
}

extension EncodingType {
  func encode(_ urlRequest: URLRequest, with parameters: [String: Any]?, images: [UIImage]?) throws -> URLRequest {
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
    
    // MARK: MultiPart 추가
    case .multiPart:
      if let parameters = parameters {
        let boundary = generateBoundaryString()
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = NSMutableData()
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"request\"\r\n\r\n")
        let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        body.append(jsonData)
        body.appendString("\r\n")
        
        if let images = images {
          for image in images {
            if let imageData = image.jpegData(compressionQuality: 0.1) {
              body.append(convertFileData(fieldName: "file", fileName: "\(Date.now)_photo.jpg", mimeType: "multipart/form-data", fileData: imageData, using: boundary))
            }
          }
        }
        
        body.appendString("--\(boundary)--")
        
        urlRequest.httpBody = body as Data
      }
    }
    return urlRequest
  }
}

// MARK: MultiPart 추가
extension EncodingType {
  private func convertFormField(named name: String,
                                value: String,
                                using boundary: String) -> String {
    let mimeType = "application/json"
    var fieldString = "--\(boundary)\r\n"
    fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
    fieldString += "Content-Type: \(mimeType)\r\n\r\n"
    fieldString += "\r\n"
    fieldString += "\(value)\r\n"
    
    return fieldString
  }
  
  private func convertFileData(fieldName: String,
                               fileName: String,
                               mimeType: String,
                               fileData: Data,
                               using boundary: String) -> Data {
    let data = NSMutableData()
    
    data.appendString("--\(boundary)\r\n")
    data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
    data.appendString("Content-Type: \(mimeType)\r\n\r\n")
    data.append(fileData)
    data.appendString("\r\n")
    
    return data as Data
  }
  
  private func generateBoundaryString() -> String {
    return "Boundary-\(UUID().uuidString)"
  }
}

// MARK: MultiPart 추가
extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
