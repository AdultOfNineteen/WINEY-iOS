//
//  NoteEmptyView.swift
//  Winey
//
//  Created by 정도현 on 10/9/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit

public struct NoteEmptyView: View {
  public var body: some View {
    VStack(spacing: 0) {
      WineyAsset.Assets.emptyNoteIcon.swiftUIImage
      
      Spacer()
        .frame(height: 13)
      
      Text("아직 노트가 없어요!")
      Text("노트를 작성해주세요 :)")
    }
    .offset(y: -50)
    .wineyFont(.headLine)
    .foregroundColor(WineyKitAsset.gray800.swiftUIColor)
  }
}

#Preview {
  NoteEmptyView()
}
