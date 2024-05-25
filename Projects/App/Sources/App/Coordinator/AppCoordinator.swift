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
import WineyKit

public struct AppCoordinator: Reducer {
  
  init() { }
  
  public struct State: Equatable, IndexedRouterState {
    static let initialState = State(
      routes: [.root(.splash(.init()))]
    )
    
    public var routes: [Route<AppScreen.State>]
  }
  
  public enum Action: IndexedRouterAction {
    case routeAction(Int, action: AppScreen.Action)
    case updateRoutes([Route<AppScreen.State>])
    case auth
    case home
  }
  
  @Dependency(\.continuousClock) var clock
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
        
      case .routeAction(_, action: .splash(._onAppear)):
        return .run { send in
          Task {
            for await notification in NotificationCenter.default.notifications(named: .userDidLogin) {
              if let loginState = notification.userInfo?["userDidLogin"] as? Bool {
                if loginState {
                  await send(.routeAction(0, action: .splash(._moveToHome)))
                } else {
                  await send(.routeAction(0, action: .splash(._moveToAuth)))
                }
              }
            }
          }
        }
        
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
        
      /// 추천 와인 관련 Action
      case let .routeAction(_, action: .tabBar(.main(.routeAction(_, action: .main(.wineCardScroll(.wineCard(id: _, action: ._navigateToCardDetail(id, data)))))))):
        state.routes.append(.push(.recommendWine(.wineDetail(id: id, data: data))))
        return .none
        
      case .routeAction(_, action: .recommendWine(.routeAction(_, action: .wineDetail(.tappedBackButton)))):
        state.routes.pop()
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
        
      /// 노트 상세보기 관련 Action
      case let .routeAction(_, action: .tabBar(.note(.routeAction(_, action: .note(.filteredNote(.noteCardScroll(.tappedNoteCard(noteId: noteId, country: country)))))))):
        state.routes.append(.push(.noteDetail(.init(noteId: noteId, country: country))))
        return .none
        
      case let .routeAction(_, action: .noteDetail(._activateBottomSheet(.setting, data))):
        state.routes.presentSheet(
          .twoSectionSheet(.init(sheetMode: .noteDetail(data)))
        )
        return .none
    
      case .routeAction(_, action: .twoSectionSheet(.noteDetail(._patchNote))):
        state.routes.dismiss()
        state.routes.append(.push(.createNote(.patchState)))
        return .none
        
      case .patchNote:
        state.routes.append(.push(.createNote(.patchState)))
        return .none
        
      case let .routeAction(_, action: .twoSectionSheet(.noteDetail(._activateBottomSheet(.remove, data)))):
        state.routes.dismiss()
        state.routes.presentSheet(.noteRemoveBottomSheet(.init(noteDetail: data)))
        return .none
        
      case .routeAction(_, action: .noteRemoveBottomSheet(.noteDetail(.tappedBackButton))):
        state.routes.dismiss()
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .noteRemoveBottomSheet(._dismissScreen)):
        state.routes.dismissAll()
        return .none
        
      case .routeAction(_, action: .noteDetail(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .createNote(.routeAction(_, action: .setAlcohol(._backToNoteDetail)))):
        state.routes.pop()
        return .none
        
      /// 노트 필터 관련 Action
      case .routeAction(_, action: .tabBar(.note(.routeAction(_, action: .note(.filteredNote(.tappedFilterButton)))))):
        state.routes.append(.push(.noteFilter(.init())))
        return .none
        
      case .routeAction(_, action: .noteFilter(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      /// 유저 정보 관련 Action
      case let .routeAction(_, action: .tabBar(.userInfo(.routeAction(_, action: .userInfo(._moveToUserInfo(userId)))))):
        state.routes.append(.push(.userSetting(.userSetting(userId: userId))))
        return .none

      case .routeAction(_, action: .userSetting(.routeAction(_, action: .settingMain(.tappedBackButton)))):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .userSetting(.routeAction(_, action: .settingMain(._moveToHome)))):
        state.routes.pop()
        state.routes = [.root(.splash(.initialState))]
        return .none
        
      case .routeAction(_, action: .userSetting(.routeAction(_, action: .signOutConfirm(.tappedConfirmButton)))):
        state.routes.pop()
        state.routes = [.root(.splash(.initialState))]
        return .none
        
      /// 유저 뱃지 관련 Action
      case let .routeAction(_, action: .tabBar(.userInfo(.routeAction(_, action: .userInfo(._moveToBadgeTap(userId)))))):
        state.routes.append(.push( .userBadge(.init(userId: userId) )))
        return .none
        
      case .routeAction(_, action: .userBadge(.tappedBackButton)):
        state.routes.pop()
        return .none
        
      /// 약관 관련 Action
      case let .routeAction(_, action: .tabBar(.userInfo(.routeAction(_, action: .userInfo(.tappedPolicySection(type)))))):
        state.routes.append(.push(.policy(.init(viewType: type))))
        return .none
        
      case .routeAction(_, action: .policy(.tappedBackButton)):
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
