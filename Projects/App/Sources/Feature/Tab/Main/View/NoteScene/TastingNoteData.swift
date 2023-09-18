//
//  TastingNoteData.swift
//  Winey
//
//  Created by 정도현 on 2023/09/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import Foundation

// MARK: Tasting Note
public struct TastingNote: Hashable, Identifiable {
  public let id: Int
  public let vintage: Int?
  public let officalAlcohol: Double?
  public let price: Int?
  public let color: String
  public let sweetness: Int
  public let acidity: Int
  public let alcohol: Int
  public let body: Int
  public let tannin: Int
  public let finish: Int
  public let memo: String
  public let buyAgain: Bool
  public let rating: Int
  public let smellKeywordList: [String]
  
  public init(
    id: Int,
    vintage: Int?,
    officalAlcohol: Double?,
    price: Int?,
    color: String,
    sweetness: Int,
    acidity: Int,
    alcohol: Int,
    body: Int, tannin: Int,
    finish: Int,
    memo: String,
    buyAgain: Bool,
    rating: Int,
    smellKeywordList: [String]
  ) {
    self.id = id
    self.vintage = vintage
    self.officalAlcohol = officalAlcohol
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
  }
}
