//
//  AppDelegate.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/17.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import AmplitudeSwift
import Foundation
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon
import SwiftUI
import UIKit
import WineyNetwork


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:])
  -> Bool {
    if AuthApi.isKakaoTalkLoginUrl(url) {
      return AuthController.handleOpenUrl(url: url)
    }
    
    if GIDSignIn.sharedInstance.handle(url) {
      return true
    }
    
    return false
  }
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    AmplitudeProvider.initProvider(apiKey: APIKeys.amplitudeApiKey)
    KakaoSDK.initSDK(appKey: APIKeys.kakaoAppKey)
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let appView = AppCoordinatorView(
      store: .init(
        initialState: .initialState,
        reducer: { AppCoordinator() })
    )
    
    window?.rootViewController = UIHostingController(rootView: appView)
    window?.makeKeyAndVisible()
    
    return true
  }
}
