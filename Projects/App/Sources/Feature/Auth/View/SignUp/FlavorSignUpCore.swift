//
//  TasteSignUpCore.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/20.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

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

public struct FlavorSignUpState: Equatable {
  var pageState: FlavorSubject = .chocolate
  var userCheck: FirstFlavorModel = .init()
  var isPresentedBottomSheet: Bool = false
}

public enum FlavorSignUpAction: Equatable {
  // MARK: - User Action
  case tappedBackButton
  case tappedOutsideOfBottomSheet
  case tappedChocolateButton(ChocolateFlavor)
  case tappedCoffeeButton(CoffeeFlavor)
  case tappedFruitButton(FruitFlavor)
  
  // MARK: - Inner Business Action
  case _presentBottomSheet(Bool)
  case _backToFirstView
  case _moveNextSubject(FlavorSubject)
  case _moveWelcomeSignUpView

  // MARK: - Inner SetState Action
}

public struct SetFlavorSignUpEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let userDefaultsService: UserDefaultsService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    userDefaultsService: UserDefaultsService
  ) {
    self.mainQueue = mainQueue
    self.userDefaultsService = userDefaultsService
  }
}

public let setFlavorSignUpReducer: Reducer<FlavorSignUpState, FlavorSignUpAction, SetFlavorSignUpEnvironment> =
Reducer { state, action, environment in
  switch action {
  case .tappedBackButton:
    return Effect(value: ._presentBottomSheet(true))
    
  case ._presentBottomSheet(let bool):
    state.isPresentedBottomSheet = bool
    return .none
    
  case .tappedChocolateButton(let choice):
    state.userCheck.chocolate = choice
    return Effect(value: ._moveNextSubject(.coffee))
    
  case .tappedCoffeeButton(let choice):
    state.userCheck.coffee = choice
    return Effect(value: ._moveNextSubject(.fruit))
    
  case ._moveNextSubject(let subject):
    state.pageState = subject
    return .none
    
  case .tappedFruitButton(let choice):
    state.userCheck.fruit = choice
    return Effect(value: ._moveWelcomeSignUpView)
    
  default:
    return .none
  }
}
.debug("FlavorSignUp Reducer")
