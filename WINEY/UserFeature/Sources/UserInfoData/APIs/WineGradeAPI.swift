//
//  WineGradeAPI.swift
//  MyPageFeature
//
//  Created by 정도현 on 2/4/24.
//

import Foundation
import UIKit
import WineyNetwork

public enum WineGradeAPI {
  case myWineGrade(userId: Int)
  case wineGrades
}

extension WineGradeAPI: EndPointType {
  public var baseURL: String {
    return .baseURL
  }
  
  public var path: String {
    switch self {
    case let .myWineGrade(userId: userId):
      return "/users/\(userId)/wine-grade"
    case .wineGrades:
      return "/users/wine-grades"
    }
  }
  
  public var method: WineyNetwork.HTTPMethod {
    switch self {
    case .myWineGrade:
      return .get
    case .wineGrades:
      return .get
    }
  }
  
  public var task: WineyNetwork.HTTPTask {
    switch self {
    case let .myWineGrade(userId: userId):
      return .requestParameters(
        parameters: [
          "userId": userId
        ],
        encoding: .queryString
      )
    case .wineGrades:
      return .requestPlain
    }
  }
}
