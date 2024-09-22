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
  /// 해당 뷰의 Swipe Gesture 기능 제거
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
