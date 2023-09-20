//
//  Testview.swift
//  Winey
//
//  Created by 정도현 on 2023/09/21.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  @State private var showRedStroke = false
  @State private var showBlueStroke = false
  
  var body: some View {
    ZStack {
      Circle()
        .trim(from: showRedStroke ? 0 : 1, to: 1)
        .stroke(style: StrokeStyle(lineWidth: 60, lineCap: .square, lineJoin: .round))
        .frame(width: 250)
        .scaleEffect(0.9)
        .foregroundColor(.red)
        .rotationEffect(.degrees(90))
        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: showRedStroke)
        .onAppear() {
          self.showRedStroke.toggle()
        }

    }
  }
}


#Preview {
  ContentView()
}
