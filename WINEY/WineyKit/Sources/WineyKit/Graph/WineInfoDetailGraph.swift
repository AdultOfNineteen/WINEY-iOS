//
//  WineInfoDetailGraph.swift
//  WineyKit
//
//  Created by 정도현 on 2023/09/14.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

public struct WineInfoDetailGraph: View {
  public let peopleStatistic: Double
  public let originalStatistic: Double
  public let infoCategory: String
  public var higherColor: Color = .wineyPoint1
  
  @State private var peopleGraphWidth: CGFloat = 0.0
  @State private var originalGraphWidth: CGFloat = 0.0
  
  public init(
    peopleStatistic: Double,
    originalStatistic: Double,
    infoCategory: String
  ) {
    self.peopleStatistic = peopleStatistic
    self.originalStatistic = originalStatistic
    self.infoCategory = infoCategory
  }
  
  public var body: some View {
    GeometryReader { geo in
      VStack(alignment: .leading) {
        Text(infoCategory)
          .wineyFont(.bodyB2)
          .foregroundColor(.wineyGray50)
        
        Text(
          originalStatistic > peopleStatistic ?
          Int(originalStatistic).description :  Int(peopleStatistic).description
        )
        .wineyFont(.bodyB2)
        .foregroundColor(.wineyGray50)
        .background(
          Image(systemName: "drop.fill")
            .resizable()
            .rotationEffect(Angle(degrees: 180))
            .frame(width: 22, height: 29)
            .foregroundColor(
              originalStatistic > peopleStatistic
              ? .wineyPoint1 : .wineyMain2
            )
            .offset(y: 2)
        )
        .offset(x: peopleStatistic > originalStatistic
                ? peopleGraphWidth - 6 : originalGraphWidth - 6, y: -18)
        .padding(.bottom, 7)
        
        ZStack(alignment: .leading) {
          if peopleStatistic > originalStatistic {
            RoundedRectangle(cornerRadius: 10)
              .frame(width: peopleGraphWidth, height: 9)
              .foregroundColor(.wineyMain2)
            RoundedRectangle(cornerRadius: 10)
              .frame(width: originalGraphWidth, height: 9)
              .foregroundColor(.wineyPoint1)
          } else {
            RoundedRectangle(cornerRadius: 10)
              .frame(width: originalGraphWidth, height: 9)
              .foregroundColor(.wineyPoint1)
            RoundedRectangle(cornerRadius: 10)
              .frame(width: peopleGraphWidth, height: 9)
              .foregroundColor(.wineyMain2)
          }
        }
        .offset(y: -15)
        .onAppear {
          withAnimation(.easeOut(duration: 1.0)) {
            peopleGraphWidth = CGFloat(peopleStatistic) * geo.size.width / 6.5
            originalGraphWidth = CGFloat(originalStatistic) * geo.size.width / 6.5
          }
        }
      }
    }
  }
}

struct WineDetailGraph_Previews: PreviewProvider {
  static var previews: some View {
    WineInfoDetailGraph(peopleStatistic: 5.0, originalStatistic: 4.0, infoCategory: "당도")
  }
}
