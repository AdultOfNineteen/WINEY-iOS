//
//  FilterManager.swift
//  Winey
//
//  Created by 정도현 on 1/13/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import SwiftUI

class FilterManager: ObservableObject {
  static let shared = FilterManager()

  private init() { }

  @Published public var rebuyFilter: Set<String> = []
  @Published public var typeFilter: Set<String> = []
  @Published public var countryFilter: Set<String> = []
}

public enum FilterType {
  case rebuy
  case type
  case country
  
  public var title: String {
    switch self {
      
    case .rebuy:
      return "재구매"
    case .type:
      return "와인종류"
    case .country:
      return "생산지"
    }
  }
}

public struct FilterInfo: Equatable, Hashable {
  public var title: String
  public var count: Int?
  public var type: FilterType
}
