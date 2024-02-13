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
    GeometryReader { geo in
      VStack {
        Spacer()
        
        HStack {
          Spacer().frame(width: 45)
          singleTab(tab: TabBarItem.main)
          
          Spacer()
          singleTab(tab: TabBarItem.map)
          
          Spacer()
          singleTab(tab: TabBarItem.note)
          
          Spacer()
          singleTab(tab: TabBarItem.userInfo)
          
          Spacer().frame(width: 45)
        }
        .padding(.vertical, 12)
        .background(WineyKitAsset.gray900.swiftUIColor)
        .cornerRadius(14, corners: [.topLeft, .topRight])
      }
      .ignoresSafeArea(edges: [.bottom])
    }
  }
}

extension TabBarInfoView {
  private func singleTab(tab: TabBarItem) -> some View {
    VStack(spacing: 4) {
      if selection == tab {
        tab.selectedIcon
        
        Text(tab.description)
          .wineyFont(.captionB1)
          .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
      } else {
        tab.defaultIcon
        
        Text(tab.description)
          .wineyFont(.captionB1)
          .foregroundColor(WineyKitAsset.gray800.swiftUIColor)
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
