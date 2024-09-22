//
//  FilterOptions.swift
//  WINEY
//
//  Created by 박혜운 on 9/22/24.
//

import Foundation

public typealias ParameterForNoteDTO = (page: Int, size: Int, order: Int, country: Set<String>, wineType: Set<String>,  buyAgain: Int?, wineId: Int?)

public struct UserTastingNotesManageModel: Equatable {
  public var filterOptions: FilterOptions = .init()
  public var contents: NoteDTO
}

public struct FilterOptions: Equatable  {
  public var sortState: SortState = .latest
  public var rebuy: Bool = false
  public var type: Set<String> = []
  public var country: Set<String> = []
}

public enum SortState: Int, CaseIterable {
  case latest = 0
  case star = 1
  
  public var title: String {
    switch self {
    case .latest:
      return "최신순"
    case .star:
      return "평점순"
    }
  }
}
