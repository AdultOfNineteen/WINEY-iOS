//
//  AuthService.swift
//  Winey
//
//  Created by 박혜운 on 2023/09/20.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Dependencies
import Foundation
import KakaoSDKUser
import WineyNetwork

public struct AuthService {
  public var socialLogin: (
    _ path: LoginPathType
  ) async -> String?
  
  public var loginState: (
    _ path: LoginPathType,
    _ accessToken: String
  ) async -> Result<LoginUserDTO, Error>
}

extension AuthService {
  static let live = {
    let networking = SocialNetworking()
    return Self(
      socialLogin: { path in
        return await networking.login(platform: path)
      },
      loginState: { path, token in
        return await Provider<AuthAPI>
          .init()
          .request(
            AuthAPI.socialLogin(
              socialType: path.rawValue.uppercased(),
              accessToken: token
            ),
            type: LoginUserDTO.self
          )
      }
    )
  }()
  //  static let mock = Self(…)
  //  static let unimplemented = Self(…)
}

extension AuthService: DependencyKey {
  public static var liveValue = Self.live
}

extension DependencyValues {
  var auth: AuthService {
    get { self[AuthService.self] }
    set { self[AuthService.self] = newValue }
  }
}

private struct SocialNetworking {
  func login(platform: LoginPathType) async -> String? {
    switch platform {
    case .kakao:
      return await kakaoLogin()
    case .google:
      return "Google AccessToken" // 가상의 토큰
    case .apple:
      return "Apple AccessToken" // 가상의 토큰
    }
  }
  
  @MainActor
  private func kakaoLogin() async -> String? {
    return await withUnsafeContinuation { continuation in
      if UserApi.isKakaoTalkLoginAvailable() {
        Task {
          UserApi.shared.loginWithKakaoTalk { oauthToken, error in
            if let error {
              continuation.resume(returning: nil)
            } else {
              let accessToken = oauthToken?.accessToken
              continuation.resume(returning: accessToken)
            }
          }
        }
      } else {
        continuation.resume(returning: nil)
      }
    }
  }
  
  private func googleLogin() async -> String? {
    return nil
  }
  
  private func appleLogin() async -> String? {
    return nil
  }
}
