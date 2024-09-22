//
//  AuthView.swift
//  WINEY
//
//  Created by 박혜운 on 9/17/24.
//

import ComposableArchitecture
import SwiftUI

struct AuthView: View {
  @Bindable var store: StoreOf<Auth>
  
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      LoginView(store: store.scope(state: \.login, action: \.login))
        .navigationBarBackButtonHidden()
    } destination: { store in
      switch store.state {
      case .phone:
        if let store = store.scope(state: \.phone, action: \.phone) {
          PhoneSignUpView(store: store)
        }
      case .code:
        if let store = store.scope(state: \.code, action: \.code) {
          CodeSignUpView(store: store)
        }
      case .flavor:
        if let store = store.scope(state: \.flavor, action: \.flavor) {
          FlavorSignUpView(store: store)
        }
      case .welcome:
        if let store = store.scope(state: \.welcome, action: \.welcome) {
          WelcomeSignUpView(store: store)
        }
      }
    }
    .onOpenURL { url in
      print("소셜 경로 타고 들어옴")
    }
  }
}

#Preview {
  AuthView(
    store: .init(
      initialState: .init(),
      reducer: { Auth()._printChanges() },
      withDependencies: { dependency in
        dependency.login = .codePassMock  // mock 중에 case 골라 확인
        dependency.signUp = .previewValue
      }
    )
  )
}
