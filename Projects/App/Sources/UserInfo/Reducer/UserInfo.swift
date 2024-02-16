//
//  UserInfo.swift
//  MyPageFeature
//
//  Created by 박혜운 on 2023/12/07.
//

import ComposableArchitecture
import Foundation

public struct UserInfo: Reducer {
  public struct State: Equatable {
    var isPresentedBottomSheet: Bool = false
    var userId: Int? = nil
    var gradeListInfo: [WineGradeInfoDTO]? = nil
    var userWineGrade: MyWineGradeDTO? = nil
    
    public init() {}
  }
  
  public enum Action {
    // MARK: - User Action
    case userBadgeButtonTapped(Int?)
    case wineyRatingButtonTapped
    case wineyRatingClosedTapped
    case userSettingTapped(Int?)
    case tappedTermsPolicy
    case tappedPersonalInfoPolicy
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _getUserInfo
    case _getWineGrades
    case _getUserWineGrade(Int)
    case _presentBottomSheet(Bool)
    case _moveToBadgeTap(Int)
    case _moveToUserInfo(Int)
    
    // MARK: - Inner SetState Action
    case _failureSocialNetworking(Error)  // 추후 경고 처리
    case _setUserInfo(UserInfoDTO)
    case _setUserWineGrade(MyWineGradeDTO)
    case _setGradeList([WineGradeInfoDTO])
    
    // MARK: - Child Action
    
  }
  
  @Dependency(\.user) var userService
  @Dependency(\.wineGrade) var wineGradeService
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case ._viewWillAppear:
      return .run { send in
        await send(._getUserInfo)
        await send(._getWineGrades)
      }
      
    case ._getUserInfo:
      return .run { send in
        switch await userService.info() {
        case let .success(data):
          await send(._setUserInfo(data))
        case let .failure(error):
          await send(._failureSocialNetworking(error))
        }
      }
      
    case ._getWineGrades:
      return .run { send in
        switch await wineGradeService.wineGrades() {
        case let .success(data):
          await send(._setGradeList(data))
        case let .failure(error):
          await send(._failureSocialNetworking(error))
        }
      }
      
    case let ._setUserInfo(data):
      state.userId = data.userId
      return .send(._getUserWineGrade(data.userId))
      
    case let ._setGradeList(data):
      state.gradeListInfo = data
      return .none
      
    case ._getUserWineGrade(let userId):
      return .run { send in
        switch await wineGradeService.myWineGrades(userId) {
        case let .success(data):
          await send(._setUserWineGrade(data))
        case let .failure(error):
          await send(._failureSocialNetworking(error))
        }
      }
      
    case let ._setUserWineGrade(data):
      state.userWineGrade = data
      return .none
      
    case .wineyRatingButtonTapped:
      return .send(._presentBottomSheet(true))
      
    case .wineyRatingClosedTapped:
      return .send(._presentBottomSheet(false))
      
    case let ._presentBottomSheet(value):
      state.isPresentedBottomSheet = value
      return .none
      
    case .userBadgeButtonTapped(let userId):
      if let userId = userId {
        return .send(._moveToBadgeTap(userId))
      } else {
        return .none  // TODO: 에러 분기처리
      }
      
    case .userSettingTapped(let userId):
      if let userId = userId {
        return .send(._moveToUserInfo(userId))
      } else {
        return .none  // TODO: 에러 분기처리
      }
      
    default:
      return .none
    }
  }
}
