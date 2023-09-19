//
//  TestView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/17.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

public struct WineAnalysisCarouselContainerView: View {
  public var body: some View {
    GeometryReader { geo in
      WineAnalysisCarousel(count: 6) {
        WineAnalysisInitView()
          .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        WinePreferNationView()
          .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        WinePreferCategoryView()
          .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        WinePreferTasteView()
          .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        WinePreferSmellView()
          .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        WinePriceView()
          .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
      }
      .frame(width: geo.size.width, height: geo.size.height)
    }
  }
}


public struct WineAnalysisCarousel<Content: View>: View {
  var content: Content
  var count: Int
  
  @State private var pageIndex: Int = 0
  
  init(count: Int, @ViewBuilder content: () -> Content) {
    self.content = content()
    self.count = count
  }
  
  public var body: some View {
    GeometryReader { geometry in
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 0) {
          ForEach(0..<count, id: \.self) { index in
            content
              .frame(width: geometry.size.width, height: geometry.size.height)
          }
        }
      }
      .content.offset(y: -CGFloat(pageIndex) * geometry.size.height)
      .gesture(
        DragGesture()
          .onEnded { gesture in
            let dragThreshold: CGFloat = 30.0
            if gesture.translation.height > dragThreshold {
              pageIndex = max(pageIndex - 1, 0)
            } else if gesture.translation.height < -dragThreshold {
              pageIndex = min(pageIndex + 1, count - 1)
            }
          }
      )
    }
    .animation(.easeInOut, value: pageIndex)
  }
}

public struct PreView: PreviewProvider {
  public static var previews: some View {
    WineAnalysisCarouselContainerView()
  }
}
