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
      Link(destination: URL(string: tipCardInfo.url)!, label: {
        ZStack {
          image.resizable()
            .aspectRatio(
              CGSize(width: 31, height: 28),
              contentMode: .fit
            )
            .clipShape(
              RoundedRectangle(cornerRadius: 10)
            )
          
          Text(tipCardInfo.title)
            .wineyFont(.captionB1)
            .lineLimit(2)
            .frame(alignment: .leading)
            .padding(.horizontal, 15)
            .padding(.top, 93)
            .foregroundStyle(WineyKitAsset.gray50.swiftUIColor)
        }
      })
    } placeholder: {
      ProgressView()
    }
  }
}
