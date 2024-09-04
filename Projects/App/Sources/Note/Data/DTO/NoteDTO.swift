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
}
