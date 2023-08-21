//
//  CodeSignUpBottomSheetContent.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

struct CodeSignUpBottomSheetContent: View {
  private let store: Store<CodeBottomSheetType, Void>
  
  init(store: Store<CodeBottomSheetType, Void>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
  
        if viewStore.state == .back {
          Text("진행을 중단하고 처음으로\n되돌아가시겠어요?")
        }
        
        if viewStore.state == .alreadySignUp {
          Text("010-1234-****님은 카카오 회원으로\n가입하신 기록이 있어요") // 전화번호, 경로 전달 필요 (미완)
        }
        
        if viewStore.state == .codeFail {
          Text("인증에 실패했어요\n 처음부터 다시 입력해주세요!")
        }
      }
      .foregroundColor(.white)
    }
  }
}
