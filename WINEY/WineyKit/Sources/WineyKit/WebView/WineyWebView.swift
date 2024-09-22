//
//  WineyWebView.swift
//  WineyKit
//
//  Created by 정도현 on 2/1/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import SwiftUI
import WebKit

public struct WineyWebView: UIViewRepresentable {
  public var url: String
  
  public init(url: String) {
    self.url = url
  }
  
  public func makeUIView(context: Context) -> some WKWebView {
    guard let url = URL(string: self.url) else {
      return WKWebView()
    }
    
    let webview = WKWebView()
    
    webview.load(URLRequest(url: url))
    
    return webview
  }
  
  public func updateUIView(_ uiView: UIViewType, context: Context) {
    
  }
}
