//
//  TipCardImage.swift
//  Winey
//
//  Created by 정도현 on 12/23/23.
//  Copyright © 2023 Winey. All rights reserved.
//

import SwiftUI
import WineyKit

public struct TipCardImage: View {
  
  public var tipCardInfo: WineTipContent
  
  public var body: some View {
    AsyncImage(url: URL(string: tipCardInfo.thumbNail)) { image in
      ZStack {
        image.resizable()
          .clipShape(
            RoundedRectangle(cornerRadius: 10)
          )
        
        VStack {
          Spacer()
          
          Text(tipCardInfo.title)
            .wineyFont(.captionB1)
            .lineLimit(2)
            .frame(alignment: .leading)
            .padding(.horizontal, 14)
            .padding(.bottom, 13)
            .foregroundStyle(.wineyGray50)
        }
      }
      .frame(height: 140)
    } placeholder: {
      ProgressView()
    }
  }
}
