//
//  SignupButton.swift
//  WineyKit
//
//  Created by 박혜운 on 2023/08/01.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

struct SignupButtonStyle: ButtonStyle {
  
  @Binding var validState: Bool
  
  init(validBy validState: Binding<Bool>) {
    self._validState = validState
  }
  
  func makeBody(configuration: Self.Configuration) -> some View {
    
      configuration
        .label
        .wineyFont(.headLine)
        .multilineTextAlignment(.center)
        .lineLimit(1)
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .disabled(!validState)
        .foregroundColor(
          validState ?
          WineyKitAsset.gray100.swiftUIColor : WineyKitAsset.gray600.swiftUIColor
        )
        .background(
          RoundedRectangle( cornerRadius: 6)
          .fill(
            validState ?
            WineyKitAsset.main1.swiftUIColor : WineyKitAsset.gray900.swiftUIColor
          )
        )
        .opacity(validState ? (configuration.isPressed ? 0.7 : 1) : 0.6)
    
  }
}

// MARK: - 사용법

struct ContentView_Previews: PreviewProvider {
  @State static var buttonState = true
  static var previews: some View {
    Button("다음", action: {})
      .buttonStyle(
        SignupButtonStyle(validBy: $buttonState)
      )
  }
}
