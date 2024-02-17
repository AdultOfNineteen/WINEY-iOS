//
//  TasteCheckButton.swift
//  WineyKit
//
//  Created by 박혜운 on 2023/08/01.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

public struct FlavorCheckButton: View {
  let mainTitle: String
  let subTitle: String
  let isSelected: Bool
  let action: () -> Void
  
  public init(
    mainTitle: String,
    subTitle: String,
    isSelected: Bool,
    action: @escaping () -> Void
  ){
    self.mainTitle = mainTitle
    self.subTitle = subTitle
    self.isSelected = isSelected
    self.action = action
  }
  
  public var body: some View {
    Button("", action: action)
    .buttonStyle(
      FlavorCheckButtonStyle(
        mainTitle: self.mainTitle,
        subTitle: self.subTitle,
        isSelected: isSelected
      )
    )
  }
}

// MARK: - 사용예시

struct FlavorCheckButton_Previews: PreviewProvider {
  @State static var buttonState = true
  static var previews: some View {
    FlavorCheckButton(
      mainTitle: "밀크 초콜릿",
      subTitle: "안달면 초콜릿을 왜 먹어?", 
      isSelected: false,
      action: {}
    )
    .frame(width: 153)
  }
}
