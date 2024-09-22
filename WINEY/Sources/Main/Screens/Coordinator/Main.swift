//
//  Main.swift
//  WINEY
//
//  Created by 박혜운 on 9/17/24.
//

import ComposableArchitecture

@Reducer
public struct Main {
  @ObservableState
  public struct State: Equatable {
    var path: StackState<MainPath.State> = .init()
  }
  
  public enum Action {
    case tappedAnalysisButton
    
    case path(StackAction<MainPath.State, MainPath.Action>)
  }
  
  public var body: some Reducer<State, Action> {
    pathReducer
    Reduce<State, Action> { state, action in
      switch action {
      default: return .none
      }
    }
  }
}
