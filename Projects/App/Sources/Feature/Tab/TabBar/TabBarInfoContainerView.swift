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
  private let content: Content
  
  
  @State private var tabs: [TabBarItem] = []
  
  init(
    selection: Binding<TabBarItem>,
    @ViewBuilder content: () -> Content
  ) {
    self._selection = selection
    self.content = content()
  }
  
  public var body: some View {
    ZStack {
      content
      
      TabBarInfoView(tabs: tabs, selection: $selection)
    }
    .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
      self.tabs = value
    }
  }
}
