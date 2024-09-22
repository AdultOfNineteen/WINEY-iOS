//
//  LogoutBottomSheetContent.swift
//  MyPageFeature
//
//  Created by 박혜운 on 12/29/23.
//

import SwiftUI
import WineyKit

struct LogoutBottomSheetContent: View {
  var body: some View {
    VStack(spacing: 5) {
      Text("로그아웃 하시겠어요?")
        .wineyFont(.bodyB1)
        .foregroundColor(.wineyGray200)

      Text("로그아웃 진행 시 초기 화면으로 돌아가요 :(")
        .wineyFont(.bodyB1)
        .foregroundColor(.wineyGray600)
    }
    .multilineTextAlignment(.center)
  }
}
