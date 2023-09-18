//
//  TestView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/17.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

public struct CarouselView<Content: View>: View {
  var content: Content
  var count: Int
  
  @State private var currentIndex: Int = 0
  private var offset: CGFloat {
    -CGFloat(currentIndex) * UIScreen.main.bounds.height
  }
  
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
              .frame(width: nil, height: geometry.size.height)
          }
        }
      }
      .content.offset(y: offset)
      .frame(width: geometry.size.width, height: geometry.size.height)
      .gesture(
        DragGesture()
          .onEnded { gesture in
            let dragThreshold: CGFloat = 50.0
            if gesture.translation.height > dragThreshold {
              currentIndex = max(currentIndex - 1, 0)
            } else if gesture.translation.height < -dragThreshold {
              currentIndex = min(currentIndex + 1, count - 1)
            }
            print(currentIndex)
          }
      )
    }
    .animation(.easeInOut)
  }
}


public struct ContentView: View {
  public var body: some View {
    GeometryReader { geometry in
      CarouselView(count: 3) {
        WinePreferNationView()
          .frame(width: geometry.size.width, height: geometry.size.height)
        WinePreferNationView()
          .frame(width: geometry.size.width, height: geometry.size.height)
        WinePreferNationView()
          .frame(width: geometry.size.width, height: geometry.size.height)
      }
      .frame(width: geometry.size.width, height: geometry.size.height)
    }
  }
}

public struct PreView: PreviewProvider {
  public static var previews: some View {
    ContentView()
  }
}

