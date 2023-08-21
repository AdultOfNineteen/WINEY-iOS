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

struct CodeSignUpBottomSheetFooter: View {
  private let store: Store<CodeSignUpState, CodeSignUpAction>
  
  init(store: Store<CodeSignUpState, CodeSignUpAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: \.bottomSheetType) { viewStore in
      VStack {
        if viewStore.state == .back {
          HStack {
            Button("아니오") {
              viewStore.send(._presentBottomSheet(false))
            }
            Button("네") {
              viewStore.send(._backToFirstView)
            }
          }
        }
        
        if viewStore.state == .alreadySignUp {
          WineyConfirmButton(
            title: "확인",
            validBy: true,
            action: {
              viewStore.send(.tappedBottomAlreadySignUpButton)
            }
          )
        }
        
        if viewStore.state == .codeFail {
          WineyConfirmButton(
            title: "확인",
            validBy: true,
            action: {
              viewStore.send(.tappedBottomFailConfirmButton)
            }
          )
        }
      }
    }
  }
}
