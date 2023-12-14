//
//  Modules.swift
//  MyPlugin
//
//  Created by 박혜운 on 2023/11/15.
//

import Foundation
import ProjectDescription

public enum ModulePath {
  case feature(Feature)
  case domain(Domain)
}

// MARK: FeatureModule
public extension ModulePath {
  enum Feature: String, CaseIterable {
    case MyPage
    case SignIn
    
    public static let name: String = "Feature"
  }
}

// MARK: DomainModule

public extension ModulePath {
  enum Domain: String, CaseIterable {
    case User
    
    public static let name: String = "Domain"
  }
}
