//
//  UserInfoView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/13.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct UserInfoView: View {
  private let store: StoreOf<UserInfo>
  @ObservedObject var viewStore: ViewStoreOf<UserInfo>
  
  public init(store: StoreOf<UserInfo>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    Text("UserInfo View")
  }
}
