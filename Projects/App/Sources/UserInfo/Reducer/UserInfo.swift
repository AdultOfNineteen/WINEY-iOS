//
//  UserInfo.swift
//  MyPageFeature
//
//  Created by 박혜운 on 2023/12/07.
//

import ComposableArchitecture
import Foundation
import SwiftUI

public struct UserInfo: Reducer {
  public struct State: Equatable {
    var isPresentedBottomSheet: Bool = false
    var userId: Int? = nil
    var userNickname: String? = nil
    var gradeListInfo: [WineGradeInfoDTO]? = nil
    var userWineGrade: MyWineGradeDTO? = nil
    var hightestGradeCount: Int = 0
    
    var needWriteNoteToNextGrade: Int = 0
    var nextWineGrade: String = "GLASS"
    
    public init() {}
  }
  
  public enum Action {
    // MARK: - User Action
    case userBadgeButtonTapped(Int?)
    case wineyRatingButtonTapped
    case wineyRatingClosedTapped
    case userSettingTapped(Int?)
    case tappedEmailSendButton
    case tappedPolicySection(WineyPolicyViewType)
    
    // MARK: - Inner Business Action
    case _viewWillAppear
    case _getUserInfo
    case _getNickName
    case _getWineGrades
    case _getUserWineGrade(Int)
    case _presentBottomSheet(Bool)
    case _moveToBadgeTap(Int)
    case _moveToUserInfo(Int)
    case _displayEmailInvalidate
    
    // MARK: - Inner SetState Action
    case _failureSocialNetworking(Error)  // 추후 경고 처리
    case _setUserInfo(UserInfoDTO)
    case _setNickname(UserNicknameDTO)
    case _setUserWineGrade(MyWineGradeDTO)
    case _setGradeList([WineGradeInfoDTO])
    
    // MARK: - Child Action
    
  }
  
  @Dependency(\.user) var userService
  @Dependency(\.wineGrade) var wineGradeService
  @Dependency(\.alert) var alertService
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case ._viewWillAppear:
      AmplitudeProvider.shared.track(event: .MYPAGE_ENTER)
      
      return .run { send in
        await send(._getUserInfo)
        await send(._getNickName)
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
      
    case ._getNickName:
      return .run { send in
        switch await userService.nickname() {
        case let .success(data):
          await send(._setNickname(data))
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
      
    case let ._setNickname(data):
      state.userNickname = data.nickname
      return .none
      
    case let ._setGradeList(data):
      state.gradeListInfo = data
      state.hightestGradeCount = data[data.count - 1].minCount
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
      switch data.expectedNextMonthGrade {
      case "GLASS":
        state.needWriteNoteToNextGrade = 3 - data.threeMonthsNoteCount
        state.nextWineGrade = "BOTTLE"
      case "BOTTLE":
        state.needWriteNoteToNextGrade = 7 - data.threeMonthsNoteCount
        state.nextWineGrade = "OAK"
      case "OAK":
        state.needWriteNoteToNextGrade = 12 - data.threeMonthsNoteCount
        state.nextWineGrade = "WINERY"
      case "WINERY":
        state.needWriteNoteToNextGrade = 0
        state.nextWineGrade = "WINERY"
      default:
        state.needWriteNoteToNextGrade = 0
        state.nextWineGrade = "BOTTLE"
      }
      return .none
      
    case .wineyRatingButtonTapped:
      return .send(._presentBottomSheet(true))
      
    case .wineyRatingClosedTapped:
      return .send(._presentBottomSheet(false))
      
    case .tappedEmailSendButton:
      EmailController.shared.sendEmail(subject: "WINEY 1:1 문의", body: "", to: "winey.official.kr@gmail.com")
      
      // 메일을 보낼 수 있는 기기와 아닌 기기 분류
      if EmailController.shared.emailValidateDevice  {
        return .none
      } else {
        return .send(._displayEmailInvalidate)
      }
      
    case ._displayEmailInvalidate:
      alertService.showAlert("해당 기기에서 메일을 보낼 수 없습니다.")
      return .none
      
    case let ._presentBottomSheet(value):
      state.isPresentedBottomSheet = value
      return .none
      
    case .userBadgeButtonTapped(let userId):
      if let userId = userId {
        AmplitudeProvider.shared.track(event: .WINEY_BADGE_CLICK)
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
