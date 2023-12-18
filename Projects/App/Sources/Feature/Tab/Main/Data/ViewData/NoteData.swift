//
//  NoteData.swift
//  Winey
//
//  Created by 정도현 on 12/19/23.
//  Copyright © 2023 Winey. All rights reserved.
//

import SwiftUI

public struct NoteData: Hashable, Identifiable {
  public let id: Int
  let wineName: String
  let country: String
  let starRating: Int
  let buyAgain: Bool
  let wineType: WineType
}
