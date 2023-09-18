//
//  MapView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/13.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

struct MapView: View {
  private let store: StoreOf<Map>
  @ObservedObject var viewStore: ViewStoreOf<Map>
  
  public init(store: StoreOf<Map>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        Text("Note View")
      }
    }
  }
}
