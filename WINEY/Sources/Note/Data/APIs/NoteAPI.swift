//
//  NoteAPI.swift
//  Winey
//
//  Created by 정도현 on 12/19/23.
//  Copyright © 2023 Winey. All rights reserved.
//

import Foundation
import UIKit
import WineyNetwork

public enum NoteAPI {
  case wineSearch(page: Int, size: Int, content: String)
  case noteDetailInfo(noteId: Int)
  case tastingNotes(page: Int, size: Int, order: Int, country: [String], wineType: [String], buyAgain: Int?, wineId: Int?)
  case createNote(createNoteData: CreateNoteRequestDTO, images: [UIImage])
  case patchNote(patchNoteData: PatchNoteRequestDTO, images: [UIImage])
  case deleteNote(noteId: Int)
  case noteFilter
  case noteCheck
}

extension NoteAPI: EndPointType {
  public var baseURL: String {
    return .baseURL
  }
  
  public var path: String {
    switch self {
    case let .noteDetailInfo(noteId):
      return "/tasting-notes/\(noteId)"
    case .wineSearch:
      return "/wines/search"
    case .tastingNotes:
      return "/tasting-notes"
    case .createNote:
      return "/tasting-notes"
    case let .patchNote(patchNoteData: patchNoteData, images: _):
      return "/tasting-notes/\(patchNoteData.noteId)"
    case let .deleteNote(noteId):
      return "/tasting-notes/\(noteId)"
    case .noteFilter:
      return "/tasting-notes/filter"
    case .noteCheck:
      return "/tasting-notes/check"
    }
  }
  
  public var method: WineyNetwork.HTTPMethod {
    switch self {
    case .noteDetailInfo:
      return .get
    case .wineSearch:
      return .get
    case .tastingNotes:
      return .get
    case .createNote:
      return .post
    case .patchNote:
      return .patch
    case .deleteNote:
      return .delete
    case .noteFilter:
      return .get
    case .noteCheck:
      return .get
    }
  }
  
  public var task: WineyNetwork.HTTPTask {
    switch self {
    case let .noteDetailInfo(noteId):
      return .requestParameters(
        parameters: ["noteId": noteId],
        encoding: .queryString
      )
      
    case let .wineSearch(page, size, content):
      return .requestParameters(
        parameters: ["page": page, "size": size, "content": content],
        encoding: .queryString
      )
      
    case let .tastingNotes(page, size, order, country, wineType, buyAgain, wineId):
      var parameter: [String: Any] =
      [
        "page": page,
        "size": size,
        "order": order,
        "buyAgain": buyAgain ?? ""
      ]
      
      if !country.isEmpty {
        parameter["countries"] = country.joined(separator: ", ")
      }
      
      if !wineType.isEmpty {
        parameter["wineTypes"] = wineType.joined(separator: ", ")
      }

      if let wineId {
        parameter["wineId"] = wineId
      }
      
      return .requestParameters(
        parameters: parameter,
        encoding: .queryString
      )
      
    case let .createNote(
      createNoteData,
      images
    ):
      var parameter: [String: Any] =
      [
        "wineId": createNoteData.wineId,
        "vintage": createNoteData.vintage,
        "officialAlcohol": createNoteData.officialAlcohol,
        "price": createNoteData.price,
        "color": createNoteData.color,
        "sweetness": createNoteData.sweetness,
        "acidity": createNoteData.acidity,
        "body": createNoteData.body,
        "tannin": createNoteData.tannin,
        "finish": createNoteData.finish,
        "memo": createNoteData.memo,
        "buyAgain": createNoteData.buyAgain,
        "rating": createNoteData.rating,
        "smellKeywordList": createNoteData.smellKeywordList?.sorted(),
        "isPublic": createNoteData.isPublic
      ]
      
      if createNoteData.alcohol > 0 {
        parameter["alcohol"] = createNoteData.alcohol
      }
      
      if createNoteData.sparkling > 0 {
        parameter["sparkling"] = createNoteData.sparkling
      }
      
      return .requestMultipartData(
        parameters: parameter,
        images: images
      )
      
    case let .patchNote(
      patchNoteData,
      images
    ):
      var parameter: [String: Any] = [
        "vintage": patchNoteData.vintage,
        "officialAlcohol": patchNoteData.officialAlcohol,
        "price": patchNoteData.price,
        "color": patchNoteData.color,
        "sweetness": patchNoteData.sweetness,
        "acidity": patchNoteData.acidity,
        "body": patchNoteData.body,
        "tannin": patchNoteData.tannin,
        "finish": patchNoteData.finish,
        "memo": patchNoteData.memo,
        "buyAgain": patchNoteData.buyAgain,
        "rating": patchNoteData.rating,
        "smellKeywordList": patchNoteData.smellKeywordList?.sorted(),
        "deleteSmellKeywordList": patchNoteData.deleteSmellKeywordList?.sorted(),
        "deleteImgList": patchNoteData.deleteImgLists?.sorted(),
        "isPublic": patchNoteData.isPublic
      ]
      
      if patchNoteData.alcohol > 0 {
        parameter["alcohol"] = patchNoteData.alcohol
      }
      
      if patchNoteData.sparkling > 0 {
        parameter["sparkling"] = patchNoteData.sparkling
      }
      
      return .requestMultipartData(
        parameters: parameter,
        images: images
      )
      
    case let .deleteNote(noteId: noteId):
      return .requestParameters(
        parameters: [
          "noteId": noteId
        ],
        encoding: .queryString
      )
    case .noteFilter:
      return .requestPlain
      
    case .noteCheck:
      return .requestPlain
    }
  }
}
