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
  
  init(bottomSheetType: SignUpBottomSheetType,
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
          //              {
          // viewStore.send(._presentBottomSheet(false))
          //            }
          ,
          rightTitle: "예",
          rightAction: { self.tappedBackButtonYesOption() }
          //              {
          //              viewStore.send(._backToFirstView)
          //            }
        )
      }
      
      
      
      if case .alreadySignUp = bottomSheetType {
        WineyConfirmButton(
          title: "확인",
          validBy: true,
          action: { self.tappedAlreadySignUpConfirm() }
          //              {
          //              viewStore.send(.tappedBottomAlreadySignUpButton)
          //            }
        )
      }
      
      if bottomSheetType == .codeFail {
        WineyConfirmButton(
          title: "확인",
          validBy: true,
          action: { self.tappedCodeFailConfirm() }
          //              {
          //              viewStore.send(.tappedBottomFailConfirmButton)
          //            }
        )
      }
      
      if bottomSheetType == .sendCode {
        WineyConfirmButton(
          title: "확인",
          validBy: true,
          action: {
            self.tappedSendCodeConfirm()
            // viewStore.send(.tappedBottomResendCodeButton)
          }
        )
      }
    }
  }
}

//stzuct CodeSignUpBottomSheetFooter: View {
//  private let store: StoreOf<CodeSignUp>
//
//
//  init(store: StoreOf<CodeSignUp>) {
//    self.store = store
//  }
//
//  var body: some View {
//    WithViewStore(store, observe: \.bottomSheetType) { viewStore in
//      VStack {
//        if viewStore.state == .back {
//          TwoOptionSelectorButtonView(
//            leftTitle: "아니오",
//            leftAction: {
//              viewStore.send(._presentBottomSheet(false))
//            },
//            rightTitle: "예",
//            rightAction: {
//              viewStore.send(._backToFirstView)
//            }
//          )
//        }
//
//        if case .alreadySignUp = viewStore.state {
//          WineyConfirmButton(
//            title: "확인",
//            validBy: true,
//            action: {
//              viewStore.send(.tappedBottomAlreadySignUpButton)
//            }
//          )
//        }
//
//        if viewStore.state == .codeFail {
//          WineyConfirmButton(
//            title: "확인",
//            validBy: true,
//            action: {
//              viewStore.send(.tappedBottomFailConfirmButton)
//            }
//          )
//        }
//
//        if viewStore.state == .resendCode {
//          WineyConfirmButton(
//            title: "확인",
//            validBy: true,
//            action: {
//              viewStore.send(.tappedBottomResendCodeButton)
//            }
//          )
//        }
//      }
//    }
//  }
//}
