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
  let circleColor: Color
  let smellKeywordList: [String]
  
  public var body: some View {
    // MARK: FEATURE
    VStack(alignment: .leading) {
      Text("Feature")
        .wineyFont(.display2)
      
      HStack(spacing: 7) {
        Circle()
          .fill(circleColor)
          .aspectRatio(contentMode: .fit)
          .frame(width: 32)
          .blur(radius: 4)
          .padding(.trailing, 2)
        
        Divider()
          .overlay(WineyKitAsset.gray900.swiftUIColor)
        
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            ForEach(smellKeywordList, id: \.self) { smell in
              Text(smell)
                .wineyFont(.captionB1)
                .padding(.horizontal, 10)
                .padding(.vertical, 9)
                .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
                .background(
                  RoundedRectangle(cornerRadius: 42)
                    .stroke(WineyKitAsset.gray700.swiftUIColor)
                )
            }
          }
          .padding(.vertical, 4)
        }
      }
    }
  }
}

#Preview {
  NoteDetailSmellFeatureView(
    circleColor: .blue,
    smellKeywordList: ["test", "Test"]
  )
}
