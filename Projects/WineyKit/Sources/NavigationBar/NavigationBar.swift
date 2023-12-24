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
  public let coloredTitle: String?
  public let leftIcon: Image?
  public var leftIconButtonAction: () -> Void = {}
  public let rightIcon: Image?
  public var rightIconButtonAction: () -> Void = {}
  public var backgroundColor: Color
  @Binding public var isRightButtonActive: Bool
  
  public init(
    title: String? = nil,
    coloredTitle: String? = nil,
    leftIcon: Image? = nil,
    leftIconButtonAction: @escaping () -> Void = {},
    rightIcon: Image? = nil,
    rightIconButtonAction: @escaping () -> Void = {},
    isRightButtonActive: Binding<Bool> = .constant(false),
    backgroundColor: Color = Color.black
  ) {
    self.title = title
    self.coloredTitle = coloredTitle
    self.leftIcon = leftIcon
    self.leftIconButtonAction = leftIconButtonAction
    self.rightIcon = rightIcon
    self.rightIconButtonAction = rightIconButtonAction
    self._isRightButtonActive = isRightButtonActive
    self.backgroundColor = backgroundColor
  }
  
  public var body: some View {
    ZStack {
      VStack(spacing: 0) {
        HStack(spacing: 0) {
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
      }
      .padding(.horizontal, 5)
        
        if let title = title {
          HStack {
            Spacer()
            
            HStack(spacing: 0) {
              Text(title)
                .foregroundColor(WineyKitAsset.gray100.swiftUIColor)
              
              if let coloredTitle = coloredTitle {
                Text(" \(coloredTitle)")
                  .foregroundColor(WineyKitAsset.main2.swiftUIColor)
              }
            }
            .wineyFont(.title2)
            
            Spacer()
          }
        }
    }
    .frame(height: 68, alignment: .center)
    .background(backgroundColor)
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
            .frame(width: 48, height: 48, alignment: .center)
        }
      }
    }
    .disabled(disabled)
  }
}

struct NavigationBar_Previews: PreviewProvider {
  static var previews: some View {
    NavigationBar(
      title: "제목",
      leftIcon:
        Image(systemName: "chevron.backward")
    )
  }
}
