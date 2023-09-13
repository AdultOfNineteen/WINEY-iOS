//
//  UserInfoScreen.swift
//  Winey
//
//  Created by 정도현 on 2023/09/13.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct UserInfoScreen: Reducer {
  public enum State: Equatable {
    case userInfo(UserInfo.State)
  }

  public enum Action {
    case userInfo(UserInfo.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(
      state: /State.userInfo,
      action: /Action.userInfo
    ) {
      UserInfo()
    }
  }
}
