//
//  SignUpView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

struct SignUpView: View {
  private let store: Store<SignUpState, SignUpAction>
  
  public init(store: Store<SignUpState, SignUpAction>) {
    self.store = store
  }
    var body: some View {
      WithViewStore(store) { viewStore in
        VStack {
          NavigationBar(
            leftIcon: Image(systemName: "arrow.backward"),
            leftIconButtonAction: {
              viewStore.send(.backButtonTapped)
            })
          Text("휴대폰 번호를 입력해주세요")
          Button("회원가입 완료") {
            viewStore.send(.signUpCompleted)
          }
        }
        .navigationBarHidden(true)
      }
    }
}

struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
    SignUpView(
      store: Store<SignUpState, SignUpAction>(
        initialState: .init(),
        reducer: setSignUpReducer,
        environment: SetSignUpEnvironment(
          mainQueue: .main,
          userDefaultsService: .live)
      )
    )
  }
}
