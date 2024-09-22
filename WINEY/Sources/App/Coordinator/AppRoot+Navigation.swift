//
//  AppRootNavigationPath.swift
//  WINEY
//
//  Created by 박혜운 on 9/17/24.
//

import ComposableArchitecture

@Reducer
public struct AppRootDestination {
  @ObservableState
  public enum State: Equatable {
    case splash(Splash.State)
    case auth(Auth.State)
    case tabBar(TabBar.State)
  }
  
  public enum Action {
    case splash(Splash.Action)
    case auth(Auth.Action)
    case tabBar(TabBar.Action)
  }
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.splash, action: \.splash) { Splash() }
    Scope(state: \.auth, action: \.auth) { Auth() }
    Scope(state: \.tabBar, action: \.tabBar) { TabBar() }
  }
}

extension AppRoot {
  var destinationReducer: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._moveToSplash:
        state.destination = .splash(.init())
        return .none
        
      case ._moveToAuth:
        state.destination = .auth(.init())
        return .none
        
      case ._moveToTabBar:
        state.destination = .tabBar(.init(selectedTab: .main, isTabHidden: false))
        return .none
        
      // MARK: - ChildReducer
      case .destination(.splash(._moveToAuth)):
        return .send(._moveToAuth)
        
      case .destination(.splash(._moveToTabBar)):
        return .send(._moveToTabBar)
        
      case .destination(.auth(.delegate(.moveToTab))):
        return .send(._moveToTabBar)
        
      case .destination(.tabBar(.delegate(.logout))):
        return .send(._moveToAuth)
        
      case .destination(.tabBar(.delegate(.signOut))):
        return .send(._moveToAuth)
        
      default: return .none
      }
    }
    .ifLet(\.destination, action: \.destination) {
      AppRootDestination()
    }
  }
}
