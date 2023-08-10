//
//  SetCategoryView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct AuthView: View {
  private let store: Store<AuthState, AuthAction>
  
  public init(store: Store<AuthState, AuthAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        Text("SetAuthView")
        Button("카카오톡 회원가입") {
          viewStore.send(.completeSocialNetworking)
        }
      }
    }
    .navigationBarHidden(true)
  }
}

struct AuthView_Previews: PreviewProvider {
  static var previews: some View {
    AuthView(
      store: Store<AuthState, AuthAction>(
        initialState: .init(),
        reducer: setAuthReducer,
        environment: SetAuthEnvironment(
          mainQueue: .main,
          userDefaultsService: .live)
      )
    )
  }
}
