//
//  NoteService.swift
//  Winey
//
//  Created by 정도현 on 12/19/23.
//  Copyright © 2023 Winey. All rights reserved.
//

import Dependencies
import Foundation
import WineyNetwork

public struct NoteService {
  public var notes: (_ page: Int, _ size: Int, _ order: Int, _ country: [String], _ wineType: [String], _  buyAgain: Int) async -> Result<NoteDTO, Error>
  public var wineSearch: (_ page: Int, _ size: Int, _ content: String) async -> Result<WineSearchDTO, Error>
}

extension NoteService {
  static let live = {
    return Self(
      notes: { page, size, order, country, wineType, buyAgain in
        let dtoResult = await Provider<NoteAPI>
          .init()
          .request(
            NoteAPI.tastingNotes(page: page, size: size, order: order, country: country, wineType: wineType, buyAgain: buyAgain),
            type: NoteDTO.self
          )
        
        switch dtoResult {
        case let .success(dto):
          return .success(dto)
        case let .failure(error):
          return .failure(error)
        }
      },
      wineSearch: { page, size, content in
        let dtoResult = await Provider<NoteAPI>
          .init()
          .request(
            NoteAPI.wineSearch(page: page, size: size, content: content),
            type: WineSearchDTO.self
          )
        
        switch dtoResult {
        case let .success(dto):
          return .success(dto)
        case let .failure(error):
          return .failure(error)
        }
      }
    )
  }()
  
  static let mock = {
    return Self(
      notes: { page, size, order, countries, wineTypes, buyAgain in
        return .success(
          NoteDTO(
            isLast: false,
            totalCnt: 1,
            contents: [
              NoteContent(
                noteId: 3,
                wineName: "test",
                country: "test",
                starRating: 3,
                buyAgain: true,
                wineType: "RED"
              )
            ]
          )
        )
      },
      wineSearch: { page, size, content in
        return .success(
          WineSearchDTO(
            isLast: false,
            totalCnt: 1,
            contents: [
              WineSearchContent(
                wineId: 1,
                type: "red",
                country: "test",
                name: "test",
                varietal: "test"
              )
            ]
          )
        )
      }
    )
  }()
}

extension NoteService: DependencyKey {
  public static var liveValue = Self.live
  public static var previewValue = Self.mock
}

extension DependencyValues {
  var note: NoteService {
    get { self[NoteService.self] }
    set { self[NoteService.self] = newValue }
  }
}
