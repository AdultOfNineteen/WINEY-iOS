//
//  WelcomeSignUpView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/21.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

struct WelcomeSignUpView: View {
  private let store: Store<WelcomeSignUpState, WelcomeSignUpAction>
  
  public init(store: Store<WelcomeSignUpState, WelcomeSignUpAction>) {
    self.store = store
  }
    var body: some View {
      WithViewStore(store) { viewStore in
        GeometryReader {_ in
          VStack(spacing: 0) {
            
            HStack(alignment: .firstTextBaseline) {
              Text("안녕하세요\n와이니에 오신 걸 환영해요!")
                .wineyFont(.title1)
              Spacer()
            }
            
            
            WineyConfirmButton(
              title: "시작하기",
              validBy: true,
              action: {
                viewStore.send(.tappedStartButton)
              }
            )
          }
        }
      }
      .navigationBarHidden(true)
  }
}

struct WelcomeSignUpView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeSignUpView(
      store: Store<WelcomeSignUpState, WelcomeSignUpAction>(
        initialState: .init(),
        reducer: setWelcomeSignUpReducer,
        environment: SetWelcomeSignUpEnvironment(
          mainQueue: .main,
          userDefaultsService: .live)
      )
    )
  }
}
