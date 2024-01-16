//
//  NoteFilterDTO.swift
//  Winey
//
//  Created by 정도현 on 1/13/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Foundation

public struct NoteFilterDTO: Codable, Equatable {
  public static func == (lhs: NoteFilterDTO, rhs: NoteFilterDTO) -> Bool {
    return lhs.countries[0].country == rhs.countries[0].country
  }
  
  public let wineTypes: [FilterTypes]
  public let countries: [FilterCountries]
}

public struct FilterTypes: Codable {
  public var type: String
  public var count: String
}

public struct FilterCountries: Codable {
  public var country: String
  public var count: String
}
