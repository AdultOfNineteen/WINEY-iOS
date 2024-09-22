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
  public var loadNotes: (_ page: Int, _ size: Int, _ order: Int, _ country: Set<String>, _ wineType: Set<String>, _  buyAgain: Int?, _  wineId: Int?) async -> Result<NoteDTO, Error>
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
      loadNotes: { page, size, order, country, wineType, buyAgain, wineId in
        let dtoResult = await Provider<NoteAPI>
          .init()
          .request(
            NoteAPI.tastingNotes(
              page: page,
              size: size,
              order: order,
              country: Array(country),
              wineType: Array(wineType),
              buyAgain: buyAgain, 
              wineId: wineId
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
