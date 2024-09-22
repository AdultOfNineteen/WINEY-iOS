//
//  File.swift
//  
//
//  Created by 박혜운 on 9/16/24.
//

import Foundation

public enum WineyFont: String, CaseIterable {
  case bold = "Pretendard-Bold"
  case medium = "Pretendard-Medium"
  case chaviera = "Chaviera"
}

public enum WineyFontType {
  case largeTitle
  case title1
  case title2
  case headLine
  case subhead
  case bodyB1
  case bodyM1
  case bodyB2
  case bodyM2
  case captionB1
  case captionM1
  case captionM2
  case captionM3
  case display1
  case display2
  case cardTitle
  
  public var font: WineyFont {
    switch self {
    case .largeTitle: return .bold
    case .title1: return .bold
    case .title2: return .bold
    case .headLine: return .bold
    case .subhead: return .medium
    case .bodyB1: return .bold
    case .bodyM1: return .medium
    case .bodyB2: return .bold
    case .bodyM2: return .medium
    case .captionB1: return .bold
    case .captionM1: return .medium
    case .captionM2: return .medium
    case .captionM3: return .chaviera
    case .display1: return .chaviera
    case .display2: return .chaviera
    case .cardTitle: return .chaviera
    }
  }
  
  public var size: CGFloat {
    switch self {
    case .largeTitle: return 32
    case .title1: return 26
    case .title2: return 20
    case .headLine: return 18
    case .subhead: return 15
    case .bodyB1: return 17
    case .bodyM1: return 17
    case .bodyB2: return 14
    case .bodyM2: return 14
    case .captionB1: return 13
    case .captionM1: return 13
    case .captionM2: return 11
    case .captionM3: return 11
    case .display1: return 54
    case .display2: return 28
    case .cardTitle: return 25
    }
  }
  
  public var lineHeight: CGFloat {
    switch self {
    case .largeTitle: return 7
    case .title1: return 3.2
    case .title2: return 5
    case .headLine: return 5
    case .subhead: return 5
    case .bodyB1: return 7
    case .bodyM1: return 7
    case .bodyB2: return 5
    case .bodyM2: return 5
    case .captionB1: return 4
    case .captionM1: return 4
    case .captionM2: return 7
    case .captionM3: return 2
    case .display1: return 0
    case .display2: return 0
    case .cardTitle: return 29
    }
  }
}
