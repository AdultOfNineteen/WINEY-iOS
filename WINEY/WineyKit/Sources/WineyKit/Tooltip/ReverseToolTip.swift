//
//  ReverseToolTip.swift
//  WineyKit
//
//  Created by 정도현 on 11/12/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import SwiftUI

public struct ReverseToolTip: View {
  let content: String
  
  public init(
    content: String
  ) {
    self.content = content
  }
  
  public var body: some View {
    ZStack {
      ReverseTooltipTrangleView()
        .rotationEffect(.degrees(180))
        .frame(width: 12)
        .offset(x: -CGFloat(Double(content.count) * 3.3), y: 12)
      
      Text(content)
        .wineyFont(.captionM2)
        .padding(.leading, 11)
        .padding(.trailing, 13)
        .foregroundColor(.wineyGray100)
        .background(
          Capsule()
            .fill(.wineyGray900)
            .frame(height: 26)
        )
    }
  }
}

public struct ReverseTooltipTrangleView: View {
  public var body: some View {
    GeometryReader { geometry in
      Path { path in
        let width = geometry.size.width
        let height = geometry.size.height
        
        let startPoint = CGPoint(x: width / 2, y: 0)
        let topRightPoint = CGPoint(x: width + 3, y: height)
        let topLeftPoint = CGPoint(x: -3, y: height)
        
        path.move(to: startPoint)
        path.addLine(to: topRightPoint)
        path.addLine(to: topLeftPoint)
        path.addLine(to: startPoint)
      }
      .fill(.wineyGray900)
    }
    .aspectRatio(1.0, contentMode: .fit)
  }
}


#Preview {
  ReverseToolTip(content: "건너뛰기를 누르면 내용이 저장되지 않아요")
}
