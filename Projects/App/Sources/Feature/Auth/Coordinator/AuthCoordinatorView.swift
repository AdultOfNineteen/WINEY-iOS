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
  private let store: Store<AuthCoordinatorState, AuthCoordinatorAction>
  
  public init(store: Store<AuthCoordinatorState, AuthCoordinatorAction>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) {
        CaseLet(
          state: /AuthScreenState.auth,
          action: AuthScreenAction.auth,
          then: AuthView.init
        )
        CaseLet(
          state: /AuthScreenState.setSignUp,
          action: AuthScreenAction.setSignUp,
          then: SignUpView.init
        )
      }
    }
  }
}
