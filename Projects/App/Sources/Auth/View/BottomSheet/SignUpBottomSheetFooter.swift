//
//  CodeSignUpBottomSheetFotter.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

struct SignUpBottomSheetFotter: View {
  private var bottomSheetType: SignUpBottomSheetType
  private let tappedBackButtonNoOption: (() -> Void)
  private let tappedBackButtonYesOption: (() -> Void)
  private let tappedAlreadySignUpConfirm: (() -> Void)
  private let tappedCodeFailConfirm: (() -> Void)
  private let tappedSendCodeConfirm: (() -> Void)
  
  init(
    bottomSheetType: SignUpBottomSheetType,
    tappedBackButtonNoOption: @escaping (() -> Void) = {},
    tappedBackButtonYesOption: @escaping (() -> Void) = {},
    tappedAlreadySignUpConfirm: @escaping (() -> Void) = {},
    tappedCodeFailConfirm: @escaping (() -> Void) = {},
    tappedSendCodeConfirm: @escaping (() -> Void) = {}
  ) {
    self.bottomSheetType = bottomSheetType
    self.tappedBackButtonNoOption = tappedBackButtonNoOption
    self.tappedBackButtonYesOption = tappedBackButtonYesOption
    self.tappedAlreadySignUpConfirm = tappedAlreadySignUpConfirm
    self.tappedCodeFailConfirm = tappedCodeFailConfirm
    self.tappedSendCodeConfirm = tappedSendCodeConfirm
  }
  
  var body: some View {
    VStack {
      if bottomSheetType == .back {
        TwoOptionSelectorButtonView(
          leftTitle: "아니오",
          leftAction: { self.tappedBackButtonNoOption() }
          ,
          rightTitle: "예",
          rightAction: { self.tappedBackButtonYesOption() }
        )
      }
      
      
      
      if case .alreadySignUp = bottomSheetType {
        WineyConfirmButton(
          title: "확인",
          validBy: true,
          action: { self.tappedAlreadySignUpConfirm() }
        )
      }
      
      if bottomSheetType == .codeFail {
        WineyConfirmButton(
          title: "확인",
          validBy: true,
          action: { self.tappedCodeFailConfirm() }
        )
      }
      
      if bottomSheetType == .sendCode {
        WineyConfirmButton(
          title: "확인",
          validBy: true,
          action: {
            self.tappedSendCodeConfirm()
          }
        )
      }
    }
  }
}