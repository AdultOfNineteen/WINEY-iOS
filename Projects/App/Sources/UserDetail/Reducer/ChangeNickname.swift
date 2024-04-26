//
//  ChangeNickname.swift
//  Winey
//
//  Created by 정도현 on 3/11/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import WineyNetwork

public struct ChangeNickname: Reducer {
  public struct State: Equatable {
    var nickName: String?
    
    var userInput: String = ""
    var buttonValidation: Bool = false
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedChangeButton
    case textEdit(inputText: String)
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _fetchNickname
    case _requestPatchNickname(String)
    case _handlePatchNicknameResponse(Result<VoidResponse, Error>)
    case _backToSetting
    
    // MARK: - Inner SetState Action
    case _setUserNickname(UserNicknameDTO)
    case _failureSocialNetworking(Error)
    
    // MARK: - Child Action
    
  }
  
  @Dependency(\.user) var userService
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case ._viewWillAppear:
      return .run { send in
        await send(._fetchNickname)
      }
      
    case .tappedBackButton:
      return .send(._backToSetting)
      
    case let .textEdit(inputText: text):
      state.userInput = text
      state.buttonValidation = !text.isEmpty && text != state.nickName && text.count <= 9
      return .none
      
    case ._fetchNickname:
      return .run { send in
        switch await userService.nickname() {
        case let .success(data):
          await send(._setUserNickname(data))
        case let .failure(error):
          await send(._failureSocialNetworking(error))
        }
      }
      
    case let ._setUserNickname(data):
      state.nickName = data.nickname
      state.userInput = data.nickname
      return .none
      
    case .tappedChangeButton:
      return .send(._requestPatchNickname(state.userInput))
      
    case let ._requestPatchNickname(nickname):
      return .run { send in
        let result = await userService.patchNickname(nickname)
        await send(._handlePatchNicknameResponse(result))
      }
      
    case ._handlePatchNicknameResponse(let result):
      switch result {
      case .success:
        return .send(._backToSetting)
        
      case .failure(let error):
        return .none
      }
        
    default:
      return .none
    }
  }
}
