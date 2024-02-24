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
  case tastingNotes(page: Int, size: Int, order: Int, country: [String], wineType: [String], buyAgain: Int?)
  case createNote(wineId: Int, vintage: String?, officialAlcohol: Int?, price: String?, color: String, sweetness: Int,
                  acidity: Int, alcohol: Int, body: Int, tannin: Int, finish: Int, memo: String, buyAgain: Bool, rating: Int, smellKeywordList: [String], images: [UIImage])
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
      
    case let .tastingNotes(page, size, order, country, wineType, buyAgain):
      return .requestParameters(
        parameters: [
          "page": page,
          "size": size,
          "order": order,
          country.isEmpty ? "c" : "countries" : country.joined(separator: ", "),
          wineType.isEmpty ? "w" : "wineTypes" : wineType.joined(separator: ", "),
          "buyAgain": buyAgain ?? ""
        ],
        encoding: .queryString
      )
    
    // MARK: MultiPart 추가
    case let .createNote(
      wineId,
      vintage,
      officialAlcohol,
      price,
      color,
      sweetness,
      acidity,
      alcohol,
      body,
      tannin,
      finish,
      memo,
      buyAgain,
      rating,
      smellKeywordList,
      images
    ):
      return .requestMultipartData(
        parameters: [
          "wineId": wineId,
          "vintage": vintage,
          "officialAlcohol": officialAlcohol,
          "price": price,
          "color": color,
          "sweetness": sweetness,
          "acidity": acidity,
          "alcohol": alcohol,
          "body": body,
          "tannin": tannin,
          "finish": finish,
          "memo": memo,
          "buyAgain": buyAgain,
          "rating": rating,
          "smellKeywordList": smellKeywordList
        ],
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
