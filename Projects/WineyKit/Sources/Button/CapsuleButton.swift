//
//  CapsuleButton.swift
//  WineyKit
//
//  Created by 정도현 on 11/30/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import SwiftUI

public struct CapsuleButton: View {
  public var title: String
  public var validation: Bool
  public var action: () -> Void
  
  public init(title: String, validation: Bool, action: @escaping () -> Void) {
    self.title = title
    self.validation = validation
    self.action = action
  }
 
  public var body: some View {
    
    Text(title)
      .wineyFont(.captionB1)
      .foregroundStyle(validation ? .white : WineyKitAsset.gray700.swiftUIColor)
      .padding(.top, 9)
      .padding(.bottom, 8)
      .padding(.horizontal, 12)
      .background(
        Capsule()
          .fill(
            validation ? WineyKitAsset.main2.swiftUIColor : .clear
          )
          .overlay(
            Capsule()
              .stroke(
                validation ? WineyKitAsset.main2.swiftUIColor : WineyKitAsset.gray900.swiftUIColor
              )
          )
      )
      .onTapGesture(perform: {
        action()
      })
  }
}
