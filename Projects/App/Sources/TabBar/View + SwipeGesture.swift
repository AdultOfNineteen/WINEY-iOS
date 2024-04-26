//
//  View + SwipeGesture.swift
//  Winey
//
//  Created by 정도현 on 3/31/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Dependencies
import SwiftUI

extension View {
  /// 스와이프로 네비게이션 가능을 해당 뷰에서만 끔
  func popGestureDisabled() -> some View {
    modifier(PopGestureDisabledViewModifier())
  }
}

struct PopGestureDisabledViewModifier: ViewModifier {
  @Dependency(\.userDefaults) var userDefaultsService
  var isOnlyDisable: Bool = false
  
  func body(content: Content) -> some View {
    content
      .task {
        userDefaultsService.saveFlag(.isPopGestureEnabled, false)
      }
      .onDisappear {
        guard !isOnlyDisable else { return }
        userDefaultsService.saveFlag(.isPopGestureEnabled, true)
      }
  }
}
