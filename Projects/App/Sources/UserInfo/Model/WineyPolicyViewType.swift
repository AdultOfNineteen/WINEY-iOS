//
//  WineyPolicyViewType.swift
//  Winey
//
//  Created by 정도현 on 4/1/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Foundation

public enum WineyPolicyViewType {
  case termsPolicy
  case personalPolicy
  
  public var navTitle: String {
    switch self {
    case .termsPolicy:
      return "서비스 이용약관"
    case .personalPolicy:
      return "개인정보 처리방침"
    }
  }
  
  public var url: String {
    switch self {
    case .termsPolicy:
      return "http://winey-api-dev-env.eba-atefsiev.ap-northeast-2.elasticbeanstalk.com/docs/service-policy.html"
    case .personalPolicy:
      return "http://winey-api-dev-env.eba-atefsiev.ap-northeast-2.elasticbeanstalk.com/docs/privacy-policy.html"
    }
  }
}
