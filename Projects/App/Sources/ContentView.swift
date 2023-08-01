//
//  ContentView.swift
//  Winey
//
//  Created by 박혜운 on 2023/07/31.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI
import WineyKit //폰트 정보

struct ContentView: View {
  var body: some View {
    VStack{
      TasteCheckButton( //의존성 테스트 코드입니다, 삭제 예정 
        mainTitle: "밀크 초콜릿",
        subTitle: "안달면 초콜릿을 왜 먹어?",
        action: {}
      )
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
      ContentView()
  }
}
