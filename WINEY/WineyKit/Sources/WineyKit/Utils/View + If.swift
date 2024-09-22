//
//  View + If.swift
//  WineyKit
//
//  Created by 박혜운 on 1/31/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import SwiftUI

public extension View {
  /// 특정 Bool 값이 true일 때, apply 클로저를 적용하는 modifier
  @ViewBuilder
  func `if`<Content: View>(_ condition: Bool, apply: (Self) -> Content) -> some View {
    if condition {
      apply(self)
    } else {
      self
    }
  }
  
  /// 특정 Optional 값이 nil이 아닐 때, apply 클로저를 적용하는 modifier
  @ViewBuilder
  func ifLet<Content: View, Value>(_ optionalValue: Optional<Value>, apply: (Self, Value) -> Content) -> some View {
    if let value = optionalValue {
      apply(self, value)
    } else {
      self
    }
  }
}
