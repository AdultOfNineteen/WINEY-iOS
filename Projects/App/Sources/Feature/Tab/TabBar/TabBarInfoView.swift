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
      VStack(spacing: 0) {
        
        HStack {
          singleTab(tab: TabBarItem.main)
          singleTab(tab: TabBarItem.note)
        }
        .cornerRadius(10, corners: [.topLeft, .topRight])
        .padding(.vertical, 20)
        
        WineyKitAsset.gray200.swiftUIColor.frame(height: keyWindow?.safeAreaInsets.bottom ?? 0)
      }
      .ignoresSafeArea(edges: [.bottom])
    }
  }
}

extension TabBarInfoView {
  private func singleTab(tab: TabBarItem) -> some View {
    VStack(spacing: 4) {
      if selection == tab {
        tab.icon
        
        Text(tab.description)
          .wineyFont(.captionB1)
          .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
      } else {
        tab.icon
        
        Text(tab.description)
          .wineyFont(.captionB1)
          .foregroundColor(WineyKitAsset.gray300.swiftUIColor)
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 12)
    .onTapGesture {
      withAnimation(.linear(duration: 0.2)) {
        selection = tab
      }
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
