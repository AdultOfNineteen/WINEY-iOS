//
//  AppCoordinator.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct AppCoordinator: Reducer {
  
  init() {
    print("AppCoordinator 생성됌")
  }
  
  public struct State: Equatable, IndexedRouterState {
    static let initialState = State(
      routes: [.root(.splash(.init()))]
    )
    
    public var routes: [Route<AppScreen.State>]
  }
  
  public enum Action: IndexedRouterAction {
    case routeAction(Int, action: AppScreen.Action)
    case updateRoutes([Route<AppScreen.State>])
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
        
      case let .routeAction(
        _, action: .auth(
          .routeAction(
            _, action: .login(
              ._moveUserStatusPage(path))
          )
        )
      ) where path == .done:
        state.routes = [
          .root(
            .tabBar(
              .init(
                main: .init(),
                map: .init(),
                note: .init(),
                userInfo: .init(),
                isTabHidden: false
              )
            ),
            embedInNavigationView: true
          )
        ]
        return .none
        
      case .routeAction(_, action: .splash(._moveToHome)):
        state.routes = [
          .root(
            .tabBar(
              .init(
                main: .init(),
                map: .init(),
                note: .init(),
                userInfo: .init(),
                isTabHidden: false
              )
            ),
            embedInNavigationView: true
          )
        ]
        return .none
        
      case .routeAction(_, action: .splash(._moveToAuth)):
        state.routes = [
          .root(
            .auth(.initialState)
          )
        ]
        return .none
        
      case .routeAction(_, action: .auth(.routeAction(_, action: .setWelcomeSignUp(.tappedStartButton)))):
        state.routes = [
          .root(
            .tabBar(
              .init(
                main: .init(),
                map: .init(),
                note: .init(),
                userInfo: .init(),
                isTabHidden: false
              )
            ),
            embedInNavigationView: true
          )
        ]
        return .none
        
      case .routeAction(_, action:
          .tabBar(
            .userInfo(
              .routeAction(_, action: .userSetting(._moveToHome))
            )
          )):
        state.routes = [.root(.auth(.initialState))]
//        state.routes = [.root(.splash(.init()))]
        return .none
        
      case .routeAction(_, action:
          .tabBar(
            .userInfo(
              .routeAction(_, action: .signOutConfirm(.tappedConfirmButton))
            )
          )):
        state.routes = [.root(.splash(.init()))]
        return .none
        
        
      /// 와인 팁 관련 Action
      case .routeAction(_, action: .tabBar(.main(.routeAction(_, action: .main(._navigateToTipCard))))):
        state.routes.append(.push(.wineTip(.tipList)))
        return .none
        
      case let .routeAction(_, action: .tabBar(.main(.routeAction(_, action: .main(.wineTip(.tappedTipCard(url: url))))))):
        state.routes.append(.push(.wineTip(.tipDetail(url: url))))
        return .none
        
      case .routeAction(_, action: .wineTip(.routeAction(_, action: .tipCardList(.tappedBackButton)))):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .wineTip(.routeAction(_, action: .tipCardDetail(._moveToMain)))):
        state.routes.pop()
        return .none
      
      /// 와인 분석 관련 Action
      case .routeAction(_, action: .tabBar(.main(.routeAction(_, action: .main(._navigateToAnalysis))))):
        state.routes.append(.push(.analysis(.initialState)))
        return .none
        
      case .routeAction(_, action: .tabBar(.note(.routeAction(_, action: .note(._navigateToAnalysis))))):
        state.routes.append(.push(.analysis(.initialState)))
        return .none
        
      case .routeAction(_, action: .analysis(.routeAction(_, action: .wineAnaylsis(.tappedBackButton)))):
        state.routes.pop()
        return .none
        
      /// Note 작성 관련 Action
      case .routeAction(_, action: .tabBar(.note(.routeAction(_, action: .note(.tappedNoteWriteButton))))):
        state.routes.append(.push(.createNote(.createState)))
        return .none
        
      case .routeAction(_, action: .createNote(.routeAction(_, action: .wineSearch(.tappedBackButton)))):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .createNote(.routeAction(_, action: .noteDone(.tappedButton)))):
        state.routes.pop()
        return .none
        
      default:
        return .none
        
      }
    }
    .forEachRoute {
      AppScreen()
    }
  }
}
