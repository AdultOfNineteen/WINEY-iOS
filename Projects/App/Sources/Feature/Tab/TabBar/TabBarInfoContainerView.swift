//
//  TabBarInfoContainerView.swift
//  Winey
//
//  Created by 정도현 on 2023/08/31.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

struct TabBarInfoContainerView<Content: View>: View {
  @Binding var selection: TabBarItem
  @Binding var isHidden: Bool
  private let content: Content
  
  @State private var tabs: [TabBarItem] = []
  
  init(
    selection: Binding<TabBarItem>,
    isHidden: Binding<Bool>,
    @ViewBuilder content: () -> Content
  ) {
    self._selection = selection
    self._isHidden = isHidden
    self.content = content()
  }
  
  public var body: some View {
    ZStack {
      content
        .zIndex(isHidden ? 1 : 0)
      
      TabBarInfoView(
        tabs: tabs,
        selection: $selection
      )
    }
    .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
      self.tabs = value
    }
  }
}
