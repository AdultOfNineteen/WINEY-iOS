//
//  MainToolTip.swift
//  WineyKit
//
//  Created by 정도현 on 2023/09/13.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

public struct MainTooltip: View {
  let content: String
  
  public init(
    content: String
  ) {
    self.content = content
  }
  
  public var body: some View {
    ZStack {
      MainTooltipTrangleView()
        .frame(width: 12)
        .offset(x: CGFloat(Double(content.count) * 3.3), y: -12)
      
      Text(content)
        .wineyFont(.captionM2)
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .foregroundColor(.wineyGray100)
        .background(
          RoundedRectangle(cornerRadius: 20)
            .fill(.wineyMain2)
        )
    }
  }
}

struct MainTooltipTrangleView: View {
  var body: some View {
    GeometryReader { geometry in
      Path { path in
        let width = geometry.size.width
        let height = geometry.size.height
        
        let startPoint = CGPoint(x: width / 2, y: 0)
        let topRightPoint = CGPoint(x: width, y: height)
        let topLeftPoint = CGPoint(x: 0, y: height)
        
        path.move(to: startPoint)
        path.addLine(to: topRightPoint)
        path.addLine(to: topLeftPoint)
        path.addLine(to: startPoint)
      }
      .fill(.wineyMain2)
    }
    .aspectRatio(1.0, contentMode: .fit)
  }
}


struct MainTooltip_Previews: PreviewProvider {
  static var previews: some View {
    MainTooltip(content: "나에게 맞는 와인을 분석해줘요!")
  }
}
