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
  let type: EmptyCase
  
  var body: some View {
    VStack(spacing: 0) {
      WineyAsset.Assets.blankNote.swiftUIImage
        .padding(.bottom, 13)
      
      VStack(spacing: 6) {
        Text(type.title)
          .wineyFont(.headLine)
        
        Text(type.subTitle)
          .wineyFont(.bodyM2)
      }
    }
    .foregroundStyle(
      WineyKitAsset.gray800.swiftUIColor
    )
  }
}

extension EmptyListInfoView {
  enum EmptyCase {
    case bookmark
    case shop
    
    var title: String {
      switch self {
      case .bookmark:
        return "아직 지정된 장소가 없어요 :("
      case .shop:
        return "등록된 장소가 없어요 :("
      }
    }
    
    var subTitle: String {
      switch self {
      case .bookmark:
        return "마음에 드는 장소를 모아봐요!"
      case .shop:
        return "다른 위치에서 검색해보세요!"
      }
    }
  }
}


#Preview {
  EmptyListInfoView(type: .shop)
}
