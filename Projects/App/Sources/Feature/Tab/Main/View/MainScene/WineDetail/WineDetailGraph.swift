//
//  WineDetailGraph.swift
//  Winey
//
//  Created by 정도현 on 2023/09/09.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Charts
import SwiftUI
import WineyKit

struct WineDetailGraph: View {
  let category: String
  let originalStatistic: Double
  let peopleStatistic: Double
  
  @State private var originalHeight: CGFloat = 0.0
  @State private var peopleHeight: CGFloat = 0.0
  @State private var originalHigh: Bool = true
  
  var body: some View {
    GeometryReader { geo in
      ZStack(alignment: .center) {
        HStack {
          Text(category)
            .wineyFont(.headLine)
            .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
          
          Spacer()
        }
        .offset(y: -160)
        
        WineDetailChartBackground()
          .offset(y: 70)
        
        HStack(spacing: 0) {
          VStack {
            Spacer()
            Rectangle()
              .frame(width: 38, height: originalHeight)
              .cornerRadius(8, corners: [.topLeft, .topRight])
              .foregroundColor(WineyKitAsset.main2.swiftUIColor)
          }
          
          Spacer()
            .frame(width: geo.size.width / 10 * 3)
          
          VStack {
            Spacer()
            Rectangle()
              .frame(width: 38, height: peopleHeight)
              .cornerRadius(8, corners: [.topLeft, .topRight])
              .foregroundColor(WineyKitAsset.point1.swiftUIColor)
          }
        }
        .offset(y: -geo.size.height / 2 + 70)
        
        HStack {
          Text(Int(originalStatistic).description)
            .frame(width: 38)
            .offset(y: -originalHeight)
            .foregroundColor(originalHigh ? WineyKitAsset.gray50.swiftUIColor : WineyKitAsset.gray700.swiftUIColor)
          
          Spacer()
            .frame(width: geo.size.width / 10 * 3)
    
          Text(Int(peopleStatistic).description)
            .frame(width: 38)
            .offset(y: -peopleHeight)
            .foregroundColor(!originalHigh ? WineyKitAsset.gray50.swiftUIColor : WineyKitAsset.gray700.swiftUIColor)
        }
        .wineyFont(.bodyB1)
        .offset(y: 50)
        
        
        HStack(spacing: 0) {
          Text("와인의 기본맛\n")
          
          Spacer()
            .frame(width: geo.size.width / 11 * 2)
          
          Text("취향이 비슷한 사람들이\n느낀 와인의 맛")
            .multilineTextAlignment(.center)
        }
        .wineyFont(.captionM2)
        .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
        .offset(y: 110)
        .padding(.leading, 25)
      }
    }
    .onAppear {
      withAnimation(.easeIn(duration: 1.0)) {
        originalHeight = CGFloat(originalStatistic / 5.0) * 150
        peopleHeight = CGFloat(peopleStatistic / 5.0) * 150
      }
      
      if originalStatistic < peopleStatistic {
        originalHigh = false
      } else {
        originalHigh = true
      }
    }
    .padding(.horizontal, 34)
  }
}

struct WineDetailGraph_Previews: PreviewProvider {
  static var previews: some View {
    WineDetailGraph(category: "당도", originalStatistic: 3.0, peopleStatistic: 1.0)
  }
}
