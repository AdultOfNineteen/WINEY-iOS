//
//  NoteAPI.swift
//  Winey
//
//  Created by 정도현 on 12/19/23.
//  Copyright © 2023 Winey. All rights reserved.
//

import Foundation
import WineyNetwork

public enum NoteAPI {
  case tastingNotes
  case noteDeatilInfo(noteId: Int)
}

extension NoteAPI: EndPointType {
  public var baseURL: String {
    return .baseURL
  }
  
  public var path: String {
    switch self {
    case let .noteDeatilInfo(noteId):
      return "/tasting-notes/\(noteId)"
    case .tastingNotes:
      return "/tasting-notes"
    }
  }
  
  public var method: WineyNetwork.HTTPMethod {
    switch self {
    case .noteDeatilInfo:
      return .get
    case .tastingNotes:
      return .get
    }
  }
  
  public var task: WineyNetwork.HTTPTask {
    switch self {
    case .noteDeatilInfo:
      return .requestPlain
    case .tastingNotes:
      return .requestPlain
    }
  }
}
