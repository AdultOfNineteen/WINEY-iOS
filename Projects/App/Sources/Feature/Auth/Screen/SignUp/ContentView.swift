//
//  ContentView.swift
//  Winey
//
//  Created by 박혜운 on 2023/07/31.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit // 폰트 정보

// 회원가입 화면 후반에 해당합니다. 현재 사용되는 곳은 없지만 일단 남겨 두었습니다
struct ContentView: View {
  @State private var isBottomSheetVisible = false
  @State private var isDetailViewVisible = false

  var body: some View {
    NavigationView {
      VStack {
        TasteCheckButton(
          mainTitle: "밀크 초콜릿",
          subTitle: "안달면 초콜릿을 왜 먹어?",
          action: {
            isBottomSheetVisible = true
          }
        )
      }
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
