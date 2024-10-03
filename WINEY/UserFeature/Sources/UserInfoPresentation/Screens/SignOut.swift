//
//  SignOut.swift
//  MyPageFeature
//
//  Created by 박혜운 on 12/29/23.
//

import ComposableArchitecture

public enum SignOutOptions: String, CaseIterable {
  case reason1 = "취향에 맞지 않은 와인을 추천해줘요"
  case reason2 = "와인에 흥미를 잃었어요"
  case reason3 = "콘텐츠가 한정적이며 잘못된 정보를 제공해요"
  case reason4 = "더 나은 앱, 웹 또는 방법을 찾았어요"
  case reason5 = "서비스 장애가 많고 이용이 불편해요"
  case reason6 = "잘 사용하지 않아요"
  case etc = "기타"
}

@Reducer
public struct SignOut {
  
  @ObservableState
  public struct State: Equatable {
    var userId: Int
    
    var isPresentedBottomSheet: Bool = false
    var selectedSignOutOption: SignOutOptions? = nil
    var userReason: String = ""
    
    var maxCommentLength: Int = 200
    var isOptionListShow: Bool = false
    
    public init(userId: Int) {
      self.userId = userId
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedLogout
    case tappedSignOutReason
    case tappedSignOutOption(SignOutOptions)
    case tappedNextButton(userId: Int, selectedOption: SignOutOptions, userReason: String)
    
    // MARK: - Inner Business Action
    case _presentBottomSheet(Bool)
    
    // MARK: - Inner SetState Action
    case _closeOption
    case _writingReason(String)
    case _limitMemo(String)
    
    // MARK: - Navigation
    case delegate(Delegate)
    // MARK: - Delegate
    
    // MARK: - Child Action
    
    public enum Delegate {
      case dismiss
      case toSignOutConfirmView(userId: Int, selectedOption: SignOutOptions, userReason: String)
    }
  }
  
  public init() {}
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .tappedBackButton:
        return .send(.delegate(.dismiss))
        
      case let .tappedNextButton(userId, selectedOption, userReason):
        return .send(.delegate(.toSignOutConfirmView(userId: userId, selectedOption: selectedOption, userReason: userReason)))
        
      case .tappedLogout:
        return .send(._presentBottomSheet(true))
        
      case .tappedSignOutReason:
        state.isOptionListShow = true
        return .none
        
      case .tappedSignOutOption(let option):
        state.selectedSignOutOption = option
        return .send(._closeOption)
        
      case let ._presentBottomSheet(value):
        state.isPresentedBottomSheet = value
        return .none
        
      case ._writingReason(let reason):
        state.userReason = reason
        return .none
        
      case ._limitMemo(let value):
        state.userReason = String(value.prefix(state.maxCommentLength))
        return .none
        
      case ._closeOption:
        state.isOptionListShow = false
        return .none
        
      default:
        return .none
      }
    }
  }
}
