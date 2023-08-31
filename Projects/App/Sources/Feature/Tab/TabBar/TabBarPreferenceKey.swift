//
//  TabBarPreferenceKey.swift
//  Winey
//
//  Created by 정도현 on 2023/08/31.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

struct TabBarItemsPreferenceKey: PreferenceKey {
  static var defaultValue: [TabBarItem] = []
  
  static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
    value += nextValue()
  }
}

struct TabBarItemViewModifier: ViewModifier {
  let tab: TabBarItem
  @Binding var selection: TabBarItem
  
  func body(content: Content) -> some View {
    content
      .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
  }
}

extension View {
  func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
    modifier(TabBarItemViewModifier(tab: tab, selection: selection))
  }
}
