//
//  NoteDetailDTO.swift
//  Winey
//
//  Created by 정도현 on 1/4/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import Foundation

public struct NoteDetailDTO: Codable, Equatable {
  public let noteId: Int
  public let noteDate: String
  public let wineType: String
  public let wineName: String
  public let region: String
  public let star: Int
  public let color: String
  public let vintage: Int?
  public let buyAgain: Bool
  public let varietal: String
  public let officialAlcohol: Double?
  public let price: Int?
  public let smellKeywordList: Set<String>
  public let myWineTaste: MyWineTaste
  public let defaultWineTaste: DefaultWineTaste
  public let tastingNoteImage: Set<TastingNoteImage>
  public let memo: String
}

public struct MyWineTaste: Hashable, Codable {
  public let sweetness: Double
  public let acidity: Double
  public let alcohol: Double
  public let body: Double
  public let tannin: Double
  public let finish: Double
}

public struct DefaultWineTaste: Hashable, Codable {
  public let sweetness: Double
  public let acidity: Double
  public let body: Double
  public let tannin: Double
}

public struct TastingNoteImage: Hashable, Codable {
  public let imgId: Int
  public let imgUrl: String
}
