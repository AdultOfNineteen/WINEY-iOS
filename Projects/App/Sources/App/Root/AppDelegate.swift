//
//  AppDelegate.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/17.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import AmplitudeSwift
import ComposableArchitecture
import Foundation
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon
import SwiftUI
import UIKit
import WineyNetwork


class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  let store = Store(initialState: AppCoordinator.State.initialState, reducer: { AppCoordinator() })
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    AmplitudeProvider.initProvider(apiKey: APIKeys.amplitudeApiKey)
    KakaoSDK.initSDK(appKey: APIKeys.kakaoAppKey)

    return true
  }
}
