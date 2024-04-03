//
//  EmptyListInfoView.swift
//  Winey
//
//  Created by 박혜운 on 3/26/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import SwiftUI
import WineyKit

struct EmptyListInfoView: View {
  var body: some View {
    VStack(spacing: 0) {
      WineyAsset.Assets.blankNote.swiftUIImage
        .padding(.bottom, 13)
      
      VStack(spacing: 6) {
        Text("아직 지정된 장소가 없어요 :(")
          .wineyFont(.headLine)
        
        Text("마음에 드는 장소를 모아봐요!")
          .wineyFont(.bodyM2)
      }
    }
    .foregroundStyle(WineyKitAsset.gray800.swiftUIColor)
  }
}


#Preview {
  EmptyListInfoView()
}
