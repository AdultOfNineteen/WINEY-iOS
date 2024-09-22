//
//  LoginPathType.swift
//  Winey
//
//  Created by 박혜운 on 2023/09/26.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Foundation

public enum LoginPathType: String, Equatable {
  case kakao
  case google
  case apple
  
  var title: String {
    switch self {
    case .kakao:
      return "카카오"
    case .google:
      return "구글"
    case .apple:
      return "애플"
    }
  }
  
  static func convert(path: String) -> Self? {
    let name = path.uppercased()
    switch name {
    case "KAKAO": 
      return .kakao
    case "GOOGLE": 
      return .google
    case "APPLE": 
      return .apple
    default: 
      return nil
    }
  }
}
