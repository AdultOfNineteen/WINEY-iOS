//
//  HighLightTextView.swift
//
//
//  Created by 정도현 on 9/29/24.
//

import SwiftUI

public struct HighLightTextView: View {
  let text: String
  let textColor: Color
  let font: Font
  let highlightText: String
  let highlightColor: Color
  var highlightFont: Font?
  
  public init(
    text: String,
    textColor: Color,
    font: Font,
    highlightText: String,
    highlightColor: Color,
    highlightFont: Font? = nil
  ) {
    self.text = text
    self.textColor = textColor
    self.font = font
    self.highlightText = highlightText
    self.highlightColor = highlightColor
    self.highlightFont = highlightFont == nil ? font : highlightFont
  }
  
  public var body: some View {
    highlightTextView
  }
  
  private var highlightTextView: some View {
    var attributeString = AttributedString(text)
    
    attributeString.foregroundColor = textColor
    attributeString.font = font
    
    if let range = attributeString.range(of: highlightText, options: .caseInsensitive) {
      attributeString[range].foregroundColor = highlightColor
      attributeString[range].font = highlightFont
    }
    
    return Text(attributeString)
  }
}
