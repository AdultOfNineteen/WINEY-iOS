//
//  KakaoSharedService.swift
//  Winey
//
//  Created by 박혜운 on 9/3/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Foundation
import Dependencies
import KakaoSDKShare
import KakaoSDKTemplate
import UIKit

// MARK: - Dependency Values

extension DependencyValues {
  // 변수명 소문자로 변경 필요
  var kakaoShare: KakaoShareClient {
    get { self[KakaoShareClient.self] }
    set { self[KakaoShareClient.self] = newValue }
  }
}

// MARK: - KakaoShareClient Client

struct KakaoShareClient {
  var share: @Sendable (KakaoShareMessage) async throws -> Void
}

extension KakaoShareClient: DependencyKey {
  static let liveValue: Self = {
    let controller = KakaoShareController()
    
    return Self(
      share: {
        try await controller.share(message: $0)
      }
    )
  }()
  
  static let testValue: Self = {
    Self(
      share: { _ in
        return
      }
    )
  }()
}

// MARK: - Controller

enum KakaoShareError: Error {
  case emptySendResult
  case invalidUrl
}

private final class KakaoShareController {
  @MainActor
  func share(message: KakaoShareMessage) async throws {
    return try await withCheckedThrowingContinuation { continuation in
      let templateId: Int64 = 111850
      let templateArguments = message.toStringDictionary()
      
      if ShareApi.isKakaoTalkSharingAvailable() {
        ShareApi.shared.shareCustom(templateId: templateId, templateArgs: templateArguments) { result, error in
          if let error {
            continuation.resume(throwing: error)
            return
          }
          
          guard let result else {
            continuation.resume(throwing: KakaoShareError.emptySendResult)
            return
          }
          
          UIApplication.shared.open(result.url)
          continuation.resume()
        }
      } else {
        guard let url = ShareApi.shared.makeCustomUrl(templateId: templateId, templateArgs: templateArguments) else {
          continuation.resume(throwing: KakaoShareError.invalidUrl)
          return
        }
        
        UIApplication.shared.open(url)
      }
    }
  }
}

private extension Encodable {
  func toStringDictionary() -> [String: String] {
    do {
      let jsonEncoder = JSONEncoder()
      let encodedData = try jsonEncoder.encode(self)
      
      let dictionaryData = try JSONSerialization.jsonObject(
        with: encodedData,
        options: .fragmentsAllowed
      ) as? [String: String]
      return dictionaryData ?? [:]
    } catch {
      return [:]
    }
  }
}
