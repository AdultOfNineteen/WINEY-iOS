//
//  NoteService.swift
//  Winey
//
//  Created by 정도현 on 12/19/23.
//  Copyright © 2023 Winey. All rights reserved.
//

import Dependencies
import Foundation
import UIKit
import WineyNetwork

public struct NoteService {
  public var notes: (_ page: Int, _ size: Int, _ order: Int, _ country: Set<String>, _ wineType: Set<String>, _  buyAgain: Int?) async -> Result<NoteDTO, Error>
  public var noteDetail: (_ noteId: Int) async -> Result<NoteDetailDTO, Error>
  public var wineSearch: (_ page: Int, _ size: Int, _ content: String) async -> Result<WineSearchDTO, Error>
  public var createNote: (_ createNoteData: CreateNoteRequestDTO, _ images: [UIImage]) async -> Result<VoidResponse, Error>
  public var patchNote: (_ patchNoteData: PatchNoteRequestDTO, _ images: [UIImage]) async -> Result<VoidResponse, Error>
  public var deleteNote: (_ noteId: Int) async -> Result<VoidResponse, Error>
  public var noteFilter: () async -> Result<NoteFilterDTO, Error>
  public var noteCheck: () async -> Result<NoteCheckDTO, Error>
}

extension NoteService {
  static let live = {
    return Self(
      notes: { page, size, order, country, wineType, buyAgain in
        let dtoResult = await Provider<NoteAPI>
          .init()
          .request(
            NoteAPI.tastingNotes(
              page: page,
              size: size,
              order: order,
              country: Array(country),
              wineType: Array(wineType),
              buyAgain: buyAgain
            ),
            type: NoteDTO.self
          )
        
        switch dtoResult {
        case let .success(dto):
          return .success(dto)
        case let .failure(error):
          return .failure(error)
        }
      },
      
      noteDetail: { noteId in
        let dtoResult = await Provider<NoteAPI>
          .init()
          .request(
            NoteAPI.noteDetailInfo(
              noteId: noteId
            ),
            type: NoteDetailDTO.self
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
      },
      
      createNote: { createNoteData, images in
        let dtoResult = await Provider<NoteAPI>
          .init()
          .request(
            NoteAPI.createNote(
              createNoteData: createNoteData,
              images: images
            ),
            type: VoidResponse.self
          )
        
        switch dtoResult {
        case let .success(dto):
          return .success(dto)
        case let .failure(error):
          return .failure(error)
        }
      },
      
      patchNote: { patchNoteData, images in
        let dtoResult = await Provider<NoteAPI>
          .init()
          .request(
            NoteAPI.patchNote(
              patchNoteData: patchNoteData,
              images: images
            ),
            type: VoidResponse.self
          )
        
        switch dtoResult {
        case let .success(dto):
          return .success(dto)
        case let .failure(error):
          return .failure(error)
        }
      },
      
      deleteNote: { noteId in
        let dtoResult = await Provider<NoteAPI>
          .init()
          .request(
            NoteAPI.deleteNote(noteId: noteId),
            type: VoidResponse.self
          )
        
        switch dtoResult {
        case let .success(dto):
          return .success(dto)
        case let .failure(error):
          return .failure(error)
        }
      },
      
      noteFilter: {
        let dtoResult = await Provider<NoteAPI>
          .init()
          .request(
            NoteAPI.noteFilter,
            type: NoteFilterDTO.self
          )
        
        switch dtoResult {
        case let .success(dto):
          return .success(dto)
        case let .failure(error):
          return .failure(error)
        }
      },
      
      noteCheck: {
        let dtoResult = await Provider<NoteAPI>
          .init()
          .request(
            NoteAPI.noteCheck,
            type: NoteCheckDTO.self
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
  
  //  static let mock = {
  //    return Self(
  //      notes: { page, size, order, countries, wineTypes, buyAgain in
  //        return .success(
  //          NoteDTO(
  //            isLast: false,
  //            totalCnt: 1,
  //            contents: [
  //              NoteContent(
  //                noteId: 3,
  //                wineName: "test",
  //                country: "test",
  //                starRating: 3,
  //                buyAgain: true,
  //                wineType: "RED"
  //              )
  //            ]
  //          )
  //        )
  //      },
  //      wineSearch: { page, size, content in
  //        return .success(
  //          WineSearchDTO(
  //            isLast: false,
  //            totalCnt: 1,
  //            contents: [
  //              WineSearchContent(
  //                wineId: 1,
  //                type: "red",
  //                country: "test",
  //                name: "test",
  //                varietal: "test"
  //              )
  //            ]
  //          )
  //        )
  //      },
  //      createNote: { wineId, vintage, officialAlcohol, price, color, sweetness, acidity, alcohol, body, tannin, finish, memo, buyAgain, rating, smellKeywordList  in
  //        return .success(
  //          VoidResponse.self
  //        )
  //      }
  //    )
  //  }()
}

extension NoteService: DependencyKey {
  public static var liveValue = Self.live
  // public static var previewValue = Self.mock
}

extension DependencyValues {
  var note: NoteService {
    get { self[NoteService.self] }
    set { self[NoteService.self] = newValue }
  }
}
