//
//  ForeceUpdate.swift
//  WINEY
//
//  Created by 정도현 on 11/2/24.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct ForeceUpdate {
  public struct State: Equatable {
    
    // TODO: REMOTE CONFIG 데이터 활용
    public let updateDescription: String = "더욱 쉽고 편리한\n테이스팅 노트 기록을 경험해보세요!"
  }
  
  public enum Action {
    
    // MARK: - UserAction
    case tappedUpdateButton
  }
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .tappedUpdateButton:
        return .none
        
      default: return .none
      }
    }
  }
}
