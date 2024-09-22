//
//  AuthService.swift
//  Winey
//
//  Created by 박혜운 on 2023/09/20.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import AuthenticationServices
import Dependencies
import Foundation
import GoogleSignIn
import KakaoSDKUser
import WineyNetwork
import UserInfoData

public struct LoginService {
  public var socialLogin: (
    _ path: LoginPathType
  ) async -> String?
  
  public var loginState: (
    _ path: LoginPathType,
    _ accessToken: String
  ) async -> Result<LoginUserDTO, Error>
}

extension LoginService {
  static let live = {
    let networking = SocialNetworking()
    return Self(
      socialLogin: { path in
        return await networking.login(platform: path)
      },
      loginState: { path, token in
        return await Provider<UserAPI>
          .init()
          .request(
            UserAPI.socialLogin(
              socialType: path.rawValue.uppercased(),
              accessToken: token
            ),
            type: LoginUserDTO.self
          )
      }
    )
  }()
  static let noneMock = {
    return Self(
      socialLogin: { path in
        return "소셜로그인토큰"
      },
      loginState: { path, token in
        return .success(
          LoginUserDTO.init(
            userId: 0,
            accessToken: "",
            refreshToken: "",
            userStatus: "",
            messageStatus: "",
            preferenceStatus: ""
          )
        )
      }
    )
  }()
  
  static let userActiveMock = {
    return Self(
      socialLogin: { path in
        return "소셜로그인토큰"
      },
      loginState: { path, token in
        return .success(
          LoginUserDTO.init(
            userId: 0,
            accessToken: "",
            refreshToken: "",
            userStatus: "ACTIVE",
            messageStatus: "",
            preferenceStatus: ""
          )
        )
      }
    )
  }()
  
  static let codePassMock = {
    return Self(
      socialLogin: { path in
        return "소셜로그인토큰"
      },
      loginState: { path, token in
        return .success(
          LoginUserDTO.init(
            userId: 0,
            accessToken: "",
            refreshToken: "",
            userStatus: "INACTIVE",
            messageStatus: "VERIFIED",
            preferenceStatus: ""
          )
        )
      }
    )
  }()
  //  static let unimplemented = Self(…)
}

extension LoginService: DependencyKey {
  public static var liveValue = Self.live
  public static var previewValue = Self.noneMock
}

extension DependencyValues {
  var login: LoginService {
    get { self[LoginService.self] }
    set { self[LoginService.self] = newValue }
  }
}

private struct SocialNetworking {
  private let appleLoginAuthService = SignInWithAppleCoordinator()
  
  func login(platform: LoginPathType) async -> String? {
    switch platform {
    case .kakao:
      return await kakaoLogin()
    case .google:
      return await googleLogin()
    case .apple:
      return await appleLogin()
    }
  }
  
  private func kakaoLogin() async -> String? {
    return await withUnsafeContinuation { continuation in
      if UserApi.isKakaoTalkLoginAvailable() {
        Task { @MainActor in
          UserApi.shared.loginWithKakaoTalk { oauthToken, error in
            if error != nil {
              continuation.resume(returning: nil)
            } else {
              let accessToken = oauthToken?.accessToken
              continuation.resume(returning: accessToken)
            }
          }
        }
      } else {
        Task { @MainActor in
          UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if error != nil {
              continuation.resume(returning: nil)
            } else {
              let accessToken = oauthToken?.accessToken
              continuation.resume(returning: accessToken)
            }
          }
        }
      }
    }
  }
  
  @MainActor
  private func googleLogin() async -> String? {

    guard let rootVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return nil }

    return try? await withCheckedThrowingContinuation { continuation in
      GIDSignIn
        .sharedInstance
        .signIn(
          withPresenting: rootVC
        ) { signInResult, error in
          if let error = error {
            print(error)
            continuation.resume(throwing: error)
          } else {
            let idToken = signInResult?.user.idToken?.tokenString
            continuation.resume(returning: idToken)
          }
        }
    }
  }
  
  private func appleLogin() async -> String? {
    return await self.appleLoginAuthService.startSignInWithAppleFlow()
  }
}

class SignInWithAppleCoordinator: NSObject, ASAuthorizationControllerDelegate {
  
  private var tokenContinuation: CheckedContinuation<String?, Never>?
  
  func startSignInWithAppleFlow() async -> String? {
    return await withCheckedContinuation { continuation in
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = []
      
      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      
      tokenContinuation = continuation
      authorizationController.performRequests()
    }
  }
  
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
    let token = appleIDCredential.identityToken,
    let tokenString = String(data: token, encoding: .utf8) {
      tokenContinuation?.resume(returning: tokenString)
    } else {
      tokenContinuation?.resume(returning: nil)
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    tokenContinuation?.resume(returning: nil)
  }
}
