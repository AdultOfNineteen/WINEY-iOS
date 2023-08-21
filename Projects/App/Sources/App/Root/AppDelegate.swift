//
//  AppDelegate.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/17.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let appView = WineyApp( // A ppView를 만들기 위해선
      store: .init( // Store를 넣어줘야 함, 아래는 Store를 만들기 위해 넣어줘야 할 파라미터
        initialState: .init(), // 초기 상태
        reducer: appReducer, // 따로 생성해둔 Reducer
        environment: .init()
      )
    )
  
    window?.rootViewController = UIHostingController(rootView: appView)
    window?.makeKeyAndVisible()
    
    return true
  }
}
