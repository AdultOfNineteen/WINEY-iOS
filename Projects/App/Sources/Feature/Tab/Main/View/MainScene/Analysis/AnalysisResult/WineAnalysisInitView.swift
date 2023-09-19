//
//  WineAnalysisInitView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit

public struct WineAnalysisInitView: View {
  public var body: some View {
    GeometryReader { geo in
      VStack(spacing: 0) {
        VStack(spacing: 0) {
          HStack(spacing: 0) {
            Text("지금까지")
              .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
            Text("\(7)개의 와인을 마셨고,")
              .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
          }
          
          HStack(spacing: 0) {
            Text("\(5)개의 와인에 대해 재구매")
              .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
            Text("의향이 있어요!")
              .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
          }
        }
        .wineyFont(.captionM1)
        .padding(.top, 22)
        
        WinePreferSmellContentView()
          .padding(.top, 76)
        
        Spacer()
        
        WineyAsset.Assets.arrowBottom.swiftUIImage
          .padding(.bottom, 64)
      }
      .frame(width: geo.size.width)
    }
  }
}

public struct WineAnalysisPieGraph: View {
  public var body: some View {
    VStack {
      
    }
  }
}


public struct WineAnalysisInitView_Previews: PreviewProvider {
  public static var previews: some View {
    WineAnalysisInitView()
  }
}
