//
//  File.swift
//  
//
//  Created by 박혜운 on 9/21/24.
//

import SwiftUI

public struct CustomVStack: View {
  let text1: String
  let text2: String
  
  public init(
    text1: String,
    text2: String
  ) {
    self.text1 = text1
    self.text2 = text2
  }
  
  public var body: some View {
    VStack(spacing: 2.4) {
      Text(text1)
      Text(text2)
    }
    .foregroundColor(.wineyGray200)
    .wineyFont(.bodyB1)
  }
}


