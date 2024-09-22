//
//  TabBarInfoView.swift
//  Winey
//
//  Created by 정도현 on 2023/08/31.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit

struct TabBarInfoView: View {
  public let tabs: [TabBarItem]
  @Binding var selection: TabBarItem
  
  private let keyWindow = UIApplication.shared.connectedScenes
    .compactMap { $0 as? UIWindowScene }
    .flatMap { $0.windows }
    .first { $0.isKeyWindow }
  
  var body: some View {
    VStack {
      Spacer()
      
      HStack(spacing: 0) {
        
        ForEach(TabBarItem.allCases, id: \.rawValue) { tab in
          singleTab(tab: tab)
          
          if tab.rawValue != 3 {
            Spacer()
          }
        }
      }
      .padding(.horizontal, 45)
      .padding(.vertical, 12)
      .background(.wineyGray900)
      .cornerRadius(14, corners: [.topLeft, .topRight])
    }
    .ignoresSafeArea(edges: [.bottom])
  }
}

extension TabBarInfoView {
  private func singleTab(tab: TabBarItem) -> some View {
    VStack(spacing: 4) {
      if selection == tab {
        tab.selectedIcon
        
        Text(tab.description)
          .wineyFont(.captionB1)
          .foregroundColor(.wineyGray50)
      } else {
        tab.defaultIcon
        
        Text(tab.description)
          .wineyFont(.captionB1)
          .foregroundColor(.wineyGray800)
      }
    }
    .padding(.bottom, 25)
    .onTapGesture {
      selection = tab
    }
  }
}

extension View {
  public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundCorners(radius: radius, corners: corners))
  }
}

fileprivate struct RoundCorners: Shape {
  var radius: CGFloat = 5
  var corners: UIRectCorner = .allCorners
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}
