//
//  PatchNoteRequestDTO.swift
//  Winey
//
//  Created by 정도현 on 2/25/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Foundation

public struct PatchNoteRequestDTO: Encodable, Equatable {
  let noteId: Int
  let vintage: String?
  let officialAlcohol: Double?
  let price: String?
  let color: String
  let sweetness: Int
  let acidity: Int
  let alcohol: Int
  let sparkling: Int
  let body: Int
  let tannin: Int
  let finish: Int
  let memo: String
  let buyAgain: Bool
  let rating: Int
  let smellKeywordList: Set<String>?  // 추가되는 향
  let deleteSmellKeywordList: Set<String>?  // 삭제되는 향
  let deleteImgLists: Set<Int>?  // 삭제되는 이미지 (int)
  let isPublic: Bool
  
  public init(
    noteId: Int,
    vintage: String?,
    officialAlcohol: Double?,
    price: String?,
    color: String,
    sweetness: Int,
    acidity: Int,
    alcohol: Int,
    sparkling: Int,
    body: Int,
    tannin: Int,
    finish: Int,
    memo: String,
    buyAgain: Bool,
    rating: Int,
    smellKeywordList: Set<String>?,
    deleteSmellKeywordList: Set<String>?,
    deleteImgLists: Set<Int>?,
    isPublic: Bool
  ) {
    self.noteId = noteId
    self.vintage = vintage
    self.officialAlcohol = officialAlcohol
    self.price = price
    self.color = color
    self.sweetness = sweetness
    self.acidity = acidity
    self.alcohol = alcohol
    self.sparkling = sparkling
    self.body = body
    self.tannin = tannin
    self.finish = finish
    self.memo = memo
    self.buyAgain = buyAgain
    self.rating = rating
    self.smellKeywordList = smellKeywordList
    self.deleteSmellKeywordList = deleteSmellKeywordList
    self.deleteImgLists = deleteImgLists
    self.isPublic = isPublic
  }
}
