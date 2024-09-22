//
//  SignUpBottomSheetType.swift
//  Winey
//
//  Created by 박혜운 on 2023/10/06.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Foundation

public enum SignUpBottomSheetType: Equatable {
  public static func == (lhs: SignUpBottomSheetType, rhs: SignUpBottomSheetType) -> Bool {
    switch (lhs, rhs) {
    case (.back, .back), (.codeFail, .codeFail), (.sendCode, .sendCode), (.codeExpired, .codeExpired), (.codeSendOver, .codeSendOver), (.codeDelayMinute, .codeDelayMinute):
      return true
    case (.alreadySignUp, .alreadySignUp):
      return true
    default:
      return false
    }
  }
  
  case back
  case sendCode
  case alreadySignUp((phone: String, path: LoginPathType))
  case codeFail
  case codeExpired
  case codeSendOver
  case codeDelayMinute
}
