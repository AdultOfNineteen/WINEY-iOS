//
//  MapCoordinatorView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/13.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import SwiftUI
import TCACoordinators

public struct MapCoordinatorView: View {
  private let store: StoreOf<MapCoordinator>
  
  public init(store: StoreOf<MapCoordinator>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) { screen in
        switch screen {
        default:
          CaseLet(
            /MapScreen.State.map,
            action: MapScreen.Action.map,
            then: MapView.init
          )
        }
      }
    }
  }
}
