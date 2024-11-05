//
//  NoteDetailSmellFeature.swift
//  Winey
//
//  Created by 정도현 on 10/19/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit

// MARK: DETAIL SMELL FEATURE
public struct NoteDetailSmellFeatureView: View {
  let circleColor: String
  let smellKeywordList: [String]
  
  public var body: some View {
    // MARK: FEATURE
    VStack(alignment: .leading, spacing: 0) {
      Text("Feature")
        .wineyFont(.display2)
      
      HStack(spacing: 7) {
        Circle()
          .fill(RadialGradient(
            colors: [
              Color(hex: circleColor),
              Color(hex: circleColor).opacity(0.5),
              .clear
            ],
            center: .center,
            startRadius: 0,
            endRadius: 20)
          )
          .frame(width: 40, height: 40)
        
        Divider()
          .overlay(.wineyGray900)
        
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack {
            ForEach(smellKeywordList, id: \.self) { smell in
              Text(smell)
                .wineyFont(.captionB1)
                .padding(.horizontal, 10)
                .padding(.vertical, 9)
                .foregroundColor(.wineyGray700)
                .background(
                  Capsule()
                    .stroke(.wineyGray900)
                )
            }
          }
          .padding(.leading, 2)
          .padding(.vertical, 4)
        }
      }
      .padding(.top, 20)
      
      HStack(spacing: -6) {
        Image(.noteDetailArrowBodyW)
        Image(.noteDetailArrowHeaderW)
      }
      .padding(.top, 8)
      .padding(.leading, 20)
      .frame(maxWidth: .infinity)
    }
  }
}

#Preview {
  NoteDetailSmellFeatureView(
    circleColor: "#213144",
    smellKeywordList: ["test", "Test"]
  )
}
