//
//  SignUpButton.swift
//  WineyKit
//
//  Created by 박혜운 on 2023/08/01.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

public struct WineyConfirmButton: View {
  var validState: Bool
  let title: String
  let action: () -> Void
  
  public init(
    title: String,
    validBy validState: Bool,
    action: @escaping () -> Void
  ){
    self.validState = validState
    self.title = title
    self.action = action
  }
  
  public var body: some View {
    Button(title, action: action)
    .buttonStyle(
      WineyConfirmButtonStyle(validBy: validState)
    )
  }
}

// MARK: - 사용예시

struct SignUpButton_Previews: PreviewProvider {
  @State static var buttonState = true
  
  static var previews: some View {
    WineyConfirmButton(
      title: "다음",
      validBy: buttonState,
      action: {}
    )
  }
}
