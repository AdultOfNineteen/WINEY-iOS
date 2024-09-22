//
//  TasteSignUpCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/20.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import UserInfoData
import WineyNetwork

public enum FlavorSubject: Int {
  case chocolate = 1
  case coffee
  case fruit
  
  func question() -> String {
    switch self {
    case .chocolate:
      return "평소 초콜릿을 먹을 때 나는?"
    case .coffee:
      return "내가 좋아하는 커피는?"
    case .fruit:
      return "내가 평소 즐겨먹는 과일은?"
    }
  }
}

@Reducer
public struct FlavorSignUp {
  @ObservableState
  public struct State: Equatable {
    var pageState: FlavorSubject = .chocolate
    var userCheck: FirstFlavorType = .init()
    
    var transitionEdge: Edge = .leading
    var bottomButtonStatus: Bool = false
    var isPresentedBottomSheet: Bool = false
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedOutsideOfBottomSheet
    case tappedChocolateButton(ChocolateFlavor)
    case tappedCoffeeButton(CoffeeFlavor)
    case tappedFruitButton(FruitFlavor)
    case tappedConfirmButton
    
    // MARK: - Inner Business Action
    case _presentBottomSheet(Bool)
    case _backToFirstView
    case _moveSubject(FlavorSubject, Edge)
    case _handlePreferenceSettingResponse(Result<VoidResponse, Error>)
    case _moveWelcomeSignUpView
    case _requestSignUp
    
    // MARK: - Inner SetState Action
  }
  
  @Dependency(\.userDefaults) var userDefaultsService
  @Dependency(\.signUp) var signUpService
  @Dependency(\.user) var userService
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .tappedBackButton:
        switch state.pageState.rawValue {
        case 1:
          return .send(._presentBottomSheet(true))
        case 2:
          return .send(._moveSubject(.chocolate, .trailing))
        case 3:
          return .send(._moveSubject(.coffee, .trailing))
        default:
          return .send(._presentBottomSheet(true))
        }
        
      case ._presentBottomSheet(let bool):
        state.isPresentedBottomSheet = bool
        return .none
        
      case .tappedChocolateButton(let choice):
        state.userCheck.chocolate = choice
        return .send(._moveSubject(.coffee, .leading))
        
      case .tappedCoffeeButton(let choice):
        state.userCheck.coffee = choice
        return .send(._moveSubject(.fruit, .leading))
        
      case ._moveSubject(let subject, let edge):
        state.transitionEdge = edge
        state.pageState = subject
        return .none
        
      case .tappedFruitButton(let choice):
        state.userCheck.fruit = choice
        state.bottomButtonStatus = true
        return .none
        
      case ._requestSignUp:
        guard let userId = userDefaultsService.loadValue(.userID),
              let chocolate = state.userCheck.chocolate?.rawValue,
              let coffee = state.userCheck.coffee?.rawValue,
              let fruit = state.userCheck.fruit?.rawValue else { return .none } // 추후 네트워킹 실패 처리로 수정
        
        return .run { send in
          let result = await signUpService.settingFlavor(userId, chocolate, coffee, fruit)
          await send(._handlePreferenceSettingResponse(result))
        }
        
      case .tappedConfirmButton:
        return .send(._requestSignUp)
        
      case ._handlePreferenceSettingResponse(.success):
        return .run { send in
          _ = await userService.connections() // API 연결
          await send(._moveWelcomeSignUpView)
        }
        
      case ._handlePreferenceSettingResponse(.failure):
        return .none
        
      default:
        return .none
      }
    }
  }
}
