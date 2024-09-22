//
//  NoteWriteDTO.swift
//  Winey
//
//  Created by 정도현 on 12/28/23.
//  Copyright © 2023 Winey. All rights reserved.
//

import Foundation

public struct CreateNoteRequestDTO: Encodable, Equatable {
  let wineId: Int
  let vintage: String?
  let officialAlcohol: Int?
  let price: String?
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
  let smellKeywordList: Set<String>?
  let isPublic: Bool
  
  public init(
    wineId: Int,
    vintage: String?,
    officialAlcohol: Int?,
    price: String?,
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
    smellKeywordList: Set<String>?,
    isPublic: Bool
  ) {
    self.wineId = wineId
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
    self.isPublic = isPublic
  }
}
