//
//  AuthCoordinatorView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import SwiftUI
import TCACoordinators

public struct AuthCoordinatorView: View {
  private let store: StoreOf<AuthCoordinator>
  
  public init(store: StoreOf<AuthCoordinator>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) { screen in
        switch screen {
        case .login:
          CaseLet(
            /AuthScreen.State.login,
            action: AuthScreen.Action.login,
            then: LoginView.init
          )
          
        case .setPhoneSignUp:
          CaseLet(
            /AuthScreen.State.setPhoneSignUp,
            action: AuthScreen.Action.setPhoneSignUp,
            then: SignUpView.init
          )
          
        case .setCodeSignUP:
          CaseLet(
            /AuthScreen.State.setCodeSignUP,
            action: AuthScreen.Action.setCodeSignUp,
            then: CodeSignUpView.init
          )
          
        case .setFlavorSignUp:
          CaseLet(
            /AuthScreen.State.setFlavorSignUp,
            action: AuthScreen.Action.setFlavorSignUp,
            then: FlavorSignUpView.init
          )
          
        case .setWelcomeSignUp:
          CaseLet(
            /AuthScreen.State.setWelcomeSignUp,
            action: AuthScreen.Action.setWelcomeSignUp,
            then: WelcomeSignUpView.init
          )
        }
      }
    }
    .onAppear{
      print("AuthCoordinatorView 생성")
    }
  }
}
