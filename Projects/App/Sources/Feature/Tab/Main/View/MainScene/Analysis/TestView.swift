//
//  TestView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/17.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

struct CarouselView<Content: View>: View {
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
  
  var body: some View {
    GeometryReader { geometry in
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 337) {
          ForEach(0..<count, id: \.self) { index in
            content
              .frame(width: nil, height: geometry.size.height)
          }
        }
      }
      .content.offset(y: offset)
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
    }    .animation(.easeInOut)
  }
}


struct ContentView: View {
  var body: some View {
    CarouselView(count: 3) {
      WinePreferNationView()
      WinePreferNationView()
      WinePreferNationView()
    }
  }
}

struct PreView: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

