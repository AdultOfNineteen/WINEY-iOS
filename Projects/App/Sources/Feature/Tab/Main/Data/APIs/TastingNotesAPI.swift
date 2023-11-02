//
//  TastingNotesAPI.swift
//  Winey
//
//  Created by 박혜운 on 2023/10/18.
//  Copyright © 2023 com.winey. All rights reserved.
//

import WineyNetwork

public enum TastingNotesAPI {
  case tasteAnalysis
}

extension TastingNotesAPI: EndPointType {
  public var baseURL: String {
    return .baseURL
  }
  
  public var path: String {
    switch self {
    case .tasteAnalysis:
      return "/tasting-notes/taste-analysis"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .tasteAnalysis:
      return .get
    }
  }
  
  public var task: WineyNetwork.HTTPTask {
    switch self {
    case .tasteAnalysis:
      return .requestPlain
    }
  }
}

