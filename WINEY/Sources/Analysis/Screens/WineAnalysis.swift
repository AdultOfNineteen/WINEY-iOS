//
//  WineAnalysis.swift
//  Winey
//
//  Created by 정도현 on 2023/09/14.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import UserInfoData

@Reducer
public struct WineAnalysis {
  
  @ObservableState
  public struct State: Equatable {
    public var isPresentedBottomSheet: Bool = false
    public var userNickname: String?
    
    public init(
      isPresentedBottomSheet: Bool
    ) {
      self.isPresentedBottomSheet = isPresentedBottomSheet
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedAnalysis
    case tappedBackButton
    case tappedConfirmButton
    case tappedOutsideOfBottomSheet
    
    // MARK: - Inner Business Action
    case _presentBottomSheet(Bool)
    case _navigateLoading(nickName: String)
    case _onAppear
    
    // MARK: - Inner SetState Action
    case _setNoteCheck(data: NoteCheckDTO)
    case _setUserNickname(data: UserNicknameDTO)
    case _failureSocialNetworking(Error)
    
    // MARK: - Child Action
  }
  
  @Dependency(\.note) var noteService
  @Dependency(\.user) var userService
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case ._onAppear:
        return .concatenate([
          .run { send in
            switch await noteService.noteCheck() {
            case let .success(data):
              await send(._setNoteCheck(data: data))
            case let .failure(error):
              await send(._failureSocialNetworking(error))
            }
          },
          .run { send in
            switch await userService.nickname() {
            case let .success(data):
              await send(._setUserNickname(data: data))
            case let .failure(error):
              await send(._failureSocialNetworking(error))
            }
          }
        ])
        
      case let ._setUserNickname(data: data):
        state.userNickname = data.nickname
        return .none
        
      case let ._setNoteCheck(data: data):
        if data.tastingNoteExists {
          return .none
        } else {
          return .send(._presentBottomSheet(true))
        }
        
      case .tappedBackButton:
        return .none
        
      case .tappedConfirmButton:
        return .send(.tappedBackButton)
        
      case .tappedAnalysis:
        if let userNickname = state.userNickname {
          return .send(._navigateLoading(nickName: userNickname))
        } else {
          return .none
        }
        
      case ._presentBottomSheet(let bool):
        state.isPresentedBottomSheet = bool
        return .none
        
      default:
        return .none
      }
    }
  }
}
