//
//  MainCoordinatorView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import SwiftUI
import TCACoordinators

public struct MainCoordinatorView: View {
  private let store: Store<MainCoordinatorState, MainCoordinatorAction>
  
  public init(store: Store<MainCoordinatorState, MainCoordinatorAction>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      VStack {
        Spacer()
        HStack {
          Spacer()
          Text("하이하이")
          Spacer()
        }
        Spacer()
      }
      .background(.pink)
    }
  }
}
