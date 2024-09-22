//
//  File.swift
//  
//
//  Created by 박혜운 on 9/16/24.
//

import SwiftUI

public extension View {
  func registerFonts() -> some View {
    WineyFont.registerAll()
    return self
  }
}

public extension WineyFont {
  static func registerAll() {
    allCases.forEach { font in
      font.register()
    }
  }
  
  private func register() {
    let name = rawValue
    guard let fontUrl = Bundle.module.url(forResource: name, withExtension: "otf") else { return }
    var error: Unmanaged<CFError>?
    CTFontManagerRegisterFontsForURL(fontUrl as CFURL, .process, &error)
    if error != nil {
      print("‼️ Fail to register font")
    }
  }
}
