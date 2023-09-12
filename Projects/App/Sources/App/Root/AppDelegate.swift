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
