//
//  NavigationBar.swift
//  WineyKit
//
//  Created by 박혜운 on 2023/08/16.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

public struct NavigationBar: View {
  public let title: String?
  public let leftIcon: Image?
  public var leftIconButtonAction: () -> Void = {}
  public let rightIcon: Image?
  public var rightIconButtonAction: () -> Void = {}
  @Binding public var isRightButtonActive: Bool
  
  public init(
    title: String? = nil,
    leftIcon: Image? = nil,
    leftIconButtonAction: @escaping () -> Void = {},
    rightIcon: Image? = nil,
    rightIconButtonAction: @escaping () -> Void = {},
    isRightButtonActive: Binding<Bool> = .constant(false)
  ) {
    self.title = title
    self.leftIcon = leftIcon
    self.leftIconButtonAction = leftIconButtonAction
    self.rightIcon = rightIcon
    self.rightIconButtonAction = rightIconButtonAction
    self._isRightButtonActive = isRightButtonActive
  }
  
  public var body: some View {
    ZStack {
      HStack {
        BarButton(
          type: .left,
          icon: leftIcon,
          action: leftIconButtonAction
        )
        
        Spacer()
        
        BarButton(
          type: .right,
          icon: rightIcon,
          action: rightIconButtonAction,
          disabled: $isRightButtonActive
        )
      }
      
      if let title = title {
        HStack {
          Spacer()
          
          Text(title)
            .foregroundColor(WineyKitAsset.gray100.swiftUIColor)
          
          Spacer()
        }
      }
    }
    .frame(height: 68, alignment: .center)
    .background(Color.black)
  }
}

fileprivate struct BarButton: View {
  private var type: `Type` = .left
  private var icon: Image?
  private var action: () -> Void = {}
  @Binding private var disabled: Bool
  
  fileprivate enum `Type` {
    case left
    case right
  }
  
  fileprivate init(
    type: `Type` = .left,
    icon: Image? = nil,
    action: @escaping () -> Void = {},
    disabled: Binding<Bool> = .constant(false)
  ) {
    self.type = type
    self.icon = icon
    self.action = action
    self._disabled = disabled
  }
  
  fileprivate var body: some View {
    Button(action: action) {
      HStack {
        if let icon = icon {
          icon
            .foregroundColor(.white)
            .frame(width: 24, height: 24, alignment: .center)
            .padding(.leading, 12)
        }
      }
    }
    .disabled(disabled)
  }
}

struct NavigationBar_Previews: PreviewProvider {
  static var previews: some View {
    NavigationBar(
      leftIcon: Image(systemName: "arrow.backward")
      )
  }
}
