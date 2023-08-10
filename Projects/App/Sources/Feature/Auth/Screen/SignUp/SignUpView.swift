//
//  SignUpView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct SignUpView: View {
  private let store: Store<SignUpState, SignUpAction>
  
  public init(store: Store<SignUpState, SignUpAction>) {
    self.store = store
  }
    var body: some View {
      WithViewStore(store) { viewStore in
        VStack {
          Text("SignUpView")
          Button("회원가입 완료") {
            viewStore.send(.signUpCompleted)
          }
        }
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
