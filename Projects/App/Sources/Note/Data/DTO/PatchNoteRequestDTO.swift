//
//  PatchNoteRequestDTO.swift
//  Winey
//
//  Created by 정도현 on 2/25/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Foundation

public struct PatchNoteRequestDTO: Encodable, Equatable {
  let vintage: Int
  let officialAlcohol: Int
  let price: Int
  let color: String
  let sweetness: Int
  let acidity: Int
  let alcohol: Int
  let body: Int
  let tannin: Int
  let finish: Int
  let memo: String
  let buyAgain: Bool
  let rating: Int
  let smellKeywordList: [String]  // 추가되는 향
  let deleteSmellKeywordList: [String]  // 삭제되는 향
  let deleteImgLists: [Int]  // 삭제되는 이미지 (int)
  
  public init(
    wineId: Int,
    vintage: Int,
    officialAlcohol: Int,
    price: Int,
    color: String,
    sweetness: Int,
    acidity: Int,
    alcohol: Int,
    body: Int,
    tannin: Int,
    finish: Int,
    memo: String,
    buyAgain: Bool,
    rating: Int,
    smellKeywordList: [String],
    deleteSmellKeywordList: [String],
    deleteImgLists: [Int]
  ) {
    self.vintage = vintage
    self.officialAlcohol = officialAlcohol
    self.price = price
    self.color = color
    self.sweetness = sweetness
    self.acidity = acidity
    self.alcohol = alcohol
    self.body = body
    self.tannin = tannin
    self.finish = finish
    self.memo = memo
    self.buyAgain = buyAgain
    self.rating = rating
    self.smellKeywordList = smellKeywordList
    self.deleteSmellKeywordList = deleteSmellKeywordList
    self.deleteImgLists = deleteImgLists
  }
}
