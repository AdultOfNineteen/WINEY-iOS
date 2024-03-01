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

struct SignUpBottomSheetContent: View {
  private var bottomSheetType: SignUpBottomSheetType
  
  init(bottomSheetType: SignUpBottomSheetType) {
    self.bottomSheetType = bottomSheetType
  }
  
  var body: some View {
    switch bottomSheetType {
      
    case .back:
      CustomVStack(text1: "진행을 중단하고 처음으로", text2: "되돌아가시겠어요?")
      
    case let .alreadySignUp((phone, type)):
      VStack(spacing: 2.4) {
        Text("\(phone.phoneNumberPrivate())님은")
          .foregroundColor(WineyKitAsset.gray200.swiftUIColor)
        HStack(spacing: 5) {
          Text("\(type.title) 소셜")
            .foregroundColor(WineyKitAsset.main3.swiftUIColor)
          Text("회원으로")
            .foregroundColor(WineyKitAsset.gray200.swiftUIColor)
        }
        Text("가입하신 기록이 있어요")
          .foregroundColor(WineyKitAsset.gray200.swiftUIColor)
      }
      .wineyFont(.bodyB1)
      
    case .codeFail:
      CustomVStack(text1: "인증에 실패했어요", text2: "처음부터 다시 입력해주세요!")
      
    case .sendCode:
      VStack(spacing: 14) {
        CustomVStack(text1: "인증번호가 발송되었어요", text2: "3분 안에 인증번호를 입력해주세요")
        Text("*인증번호 요청 3회 초과 시 5분 제한")
          .wineyFont(.captionM2)
          .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
      }
      
    case .codeExpired:
      CustomVStack(text1: "인증번호 재전송 버튼을 눌러", text2: "새로운 인증번호를 입력해주세요!")
    
    case .codeSendOver:
      CustomVStack(text1: "인증 요청 제한 횟수를 초과했어요", text2: "5분 뒤 처음부터 진행해주세요!")
    }
  }
}

struct CustomVStack: View {
  let text1: String
  let text2: String
  
  init(
    text1: String,
    text2: String
  ) {
    self.text1 = text1
    self.text2 = text2
  }
  
  var body: some View {
    VStack(spacing: 2.4) {
      Text(text1)
      Text(text2)
    }
    .foregroundColor(WineyKitAsset.gray200.swiftUIColor)
    .wineyFont(.bodyB1)
  }
}

extension String {
  func phoneNumberPrivate() -> String {
    return self.dropLast(4) + "****"
  }
}
