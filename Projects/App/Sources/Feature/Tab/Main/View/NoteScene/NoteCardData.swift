//
//  TastingNoteData.swift
//  Winey
//
//  Created by 정도현 on 2023/09/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import SwiftUI

public struct NoteCardData: Identifiable, Equatable {
  public let id: Int
  public let noteDate: String
  public let wineType: WineType
  public let wineName: String
  public let region: String
  public let star: Double
  public let color: Color
  public let buyAgain: Bool
  public let varietal: String
  public let officialAlcohol: Double
  public let price: Double
  public let smellKeywordList: [String]
  public let myWineTaste: MyWineTaste
  public let defaultWineTaste: DefaultWineTaste
  public let memo: String
}

public struct MyWineTaste: Hashable {
  public let description: String
  public let sweetness: Double
  public let acidity: Double
  public let alcohol: Double
  public let body: Double
  public let tannin: Double
  public let finish: Double
}

public struct DefaultWineTaste: Hashable {
  public let description: String
  public let sweetness: Double
  public let acidity: Double
  public let body: Double
  public let tannin: Double
}
