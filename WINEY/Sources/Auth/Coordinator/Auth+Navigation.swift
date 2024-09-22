//
//  Auth+Navigation.swift
//  WINEY
//
//  Created by 박혜운 on 9/21/24.
//

import ComposableArchitecture
import UserInfoData

@Reducer
public struct AuthPath {
  
  @ObservableState
  public enum State: Equatable {
    case phone(PhoneSignUp.State)
    case code(CodeSignUp.State)
    case flavor(FlavorSignUp.State)
    case welcome(WelcomeSignUp.State)
  }
  
  public enum Action {
    case phone(PhoneSignUp.Action)
    case code(CodeSignUp.Action)
    case flavor(FlavorSignUp.Action)
    case welcome(WelcomeSignUp.Action)
  }
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.phone, action: \.phone) { PhoneSignUp() }
    Scope(state: \.code, action: \.code) { CodeSignUp() }
    Scope(state: \.flavor, action: \.flavor) { FlavorSignUp() }
    Scope(state: \.welcome, action: \.welcome) { WelcomeSignUp() }
  }
}

extension Auth {
  var pathReducer: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case let .login(._moveUserStatusPage(page)):
        switch page {
        case .done:
          return .send(.delegate(.moveToTab))
        case .code:
          state.path.append(.phone(.init()))
        case .flavor:
          state.path.append(.flavor(.init()))
        }
        return .none
        
      case let .path(action):
        switch action {
        case let .element(id, action: .phone(.tappedBackButton)):
          state.path.pop(from: id)
          return .none
          
        case let .element(_, action: .phone(._moveCodeSignUpView(phone))):
          state.path.append(.code(.init(phoneNumber: phone)))
          return .none
          
        case .element(_, action: .code(._backToFirstView)):
          state.path.removeAll()
          return .none
          
        case let .element(id, action: .code(._movePhoneNumberView)):
          state.path.pop(from: id)
          return .none
          
        case .element(_, action: .code(._moveFlavorSignUpView)):
          state.path.append(.flavor(.init()))
          return .none
        
        case .element(_, action: .flavor(._backToFirstView)):
          state.path.removeAll()
          return .none
          
        case .element(_, action: .flavor(._moveWelcomeSignUpView)):
          state.path.append(.welcome(.init()))
          return .none
          
        case .element(id: _, action: .welcome(.tappedStartButton)):
          return .send(.delegate(.moveToTab))
          
        default: return .none
        }
        
      default: return .none
      }
    }
    .forEach(\.path, action: \.path) {
      AuthPath()
    }
  }
}
