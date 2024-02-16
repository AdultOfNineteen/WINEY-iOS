//
//  NoteDTO.swift
//  Winey
//
//  Created by 정도현 on 12/19/23.
//  Copyright © 2023 Winey. All rights reserved.
//

import Foundation

public struct NoteDTO: Codable, Equatable {
  let isLast: Bool
  let totalCnt: Int
  let contents: [NoteContent]
}

public struct NoteContent: Codable, Equatable {
  let noteId: Int
  let wineName: String
  let country: String
  let starRating: Int
  let buyAgain: Bool
  let wineType: String
}