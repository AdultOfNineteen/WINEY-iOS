//
//  WineyDegree.swift
//  MyPageFeatureInterface
//
//  Created by 박혜운 on 12/21/23.
//

import Foundation

enum WineyRating: CaseIterable {
  case glass, bottle, oak, winery
  
  var title: String {
    switch self {
    case .glass:
      return "GLASS"
    case .bottle:
      return "BOTTLE"
    case .oak:
      return "OAK"
    case .winery:
      return "WINERY"
    }
  }
  
  var description: String {
    switch self {
    case .glass:
      return "테이스팅 노트 0-2개 작성"
    case .bottle:
      return "테이스팅 노트 3-6개 작성"
    case .oak:
      return "테이스팅 노트 7-11개 작성"
    case .winery:
      return "테이스팅 노트 12개 작성"
    }
  }
  
  var degree: CGFloat {
    switch self {
    case .glass:
      return 0
    case .bottle:
      return CGFloat(3)/12
    case .oak:
      return CGFloat(7)/12
    case .winery:
      return 12/12
    }
  }
}
