//
//  PlainList.swift
//  WineyKit
//
//  Created by 박혜운 on 4/1/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import SwiftUI


/// 가장 기본 형태의 List
/// - SwiftUI 기본 List 스타일에서 inset, separator 를 제거한 형태
///
/// - description: 내부 사이즈가 늘었다 줄었다 해야 하거나 (Expandable), 셀의 재사용 효율성이 필요할 때 사용
public struct PlainList<Content: View>: View {
  
  public init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }
  
  var content: Content
  
  public var body: some View {
    List {
      content
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
    }
    .listStyle(.plain)
    .environment(\.defaultMinListRowHeight, 0)
  }
}
