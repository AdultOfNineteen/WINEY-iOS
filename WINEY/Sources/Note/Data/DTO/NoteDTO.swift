//
//  NoteDTO.swift
//  Winey
//
//  Created by 정도현 on 12/19/23.
//  Copyright © 2023 Winey. All rights reserved.
//

import Foundation

public struct NoteDTO: Codable, Equatable {
  var isLast: Bool
  var totalCnt: Int
  var contents: [NoteContent]
  
  init(isLast: Bool, totalCnt: Int, contents: [NoteContent]) {
    self.isLast = isLast
    self.totalCnt = totalCnt
    self.contents = contents
  }
}

public struct NoteContent: Codable, Equatable {
  let noteId: Int
  let tastingNoteNo: Int
  let wineName: String
  let country: String
  let varietal: String
  let starRating: Int
  let buyAgain: Bool
  let wineType: String
  let userNickname : String
  let noteDate : String
  let `public`: Bool
  
  public init(noteId: Int, tastingNoteNo: Int, wineName: String, country: String, varietal: String, starRating: Int, buyAgain: Bool, wineType: String, userNickname: String, noteDate: String, public: Bool) {
    self.noteId = noteId
    self.tastingNoteNo = tastingNoteNo
    self.wineName = wineName
    self.country = country
    self.varietal = varietal
    self.starRating = starRating
    self.buyAgain = buyAgain
    self.wineType = wineType
    self.userNickname = userNickname
    self.noteDate = noteDate
    self.public = `public`
  }
}

extension NoteDTO {
  static let none = Self.init(isLast: true, totalCnt: 0, contents: [])
  static let mock = Self.init(isLast: true, totalCnt: 3, contents: [.mock])
}

extension NoteContent {
  static let mock = Self(noteId: 0, tastingNoteNo: 1, wineName: "test1", country: "test1", varietal: "11", starRating: 5, buyAgain: true, wineType: "RED", userNickname: "보노", noteDate: "20220912", public: true)
}
