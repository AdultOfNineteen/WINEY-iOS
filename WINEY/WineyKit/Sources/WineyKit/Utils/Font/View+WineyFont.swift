//
//  Font+.swift
//  PalangPalang
//
//  Created by 박혜운 on 9/16/24.
//  Copyright © 2024 com.mc3. All rights reserved.
//

import SwiftUI

public extension View {
  func wineyFont(_ fontStyle: WineyFontType) -> some View {
    modifier(WineyFontViewModifier(wineyFont: fontStyle))
  }
}


public struct WineyFontViewModifier: ViewModifier {
  public let wineyFont: WineyFontType
  
  public func body(content: Content) -> some View {
    let uiFont = UIFont(
      name: wineyFont.font.rawValue,
      size: wineyFont.size
    ) ?? UIFont.systemFont(ofSize: wineyFont.size)
//    let lineSpacing = wineyFont.lineHeight - uiFont.lineHeight
    
    content
      .font(.winey(wineyFont.font, size: wineyFont.size))
//      .lineSpacing(lineSpacing)
//      .padding(.vertical, lineSpacing / 2)
  }
}
