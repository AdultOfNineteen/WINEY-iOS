//
//  NoteCardScroll.swift
//  Winey
//
//  Created by 정도현 on 10/19/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct NoteCardScroll: Reducer {
  public struct State: Equatable {
    public var noteCards: IdentifiedArrayOf<NoteCardData>
    
    public init() {
      self.noteCards = [
        NoteCardData(
          id: 0,
          noteDate: "2023.10.11",
          wineType: .red,
          wineName: "test",
          region: "test",
          star: 3.0,
          color: Color.blue,
          buyAgain: true,
          varietal: "test",
          officialAlcohol: 24.0,
          price: 5,
          smellKeywordList: ["test"],
          myWineTaste: MyWineTaste(
            sweetness: 3.0,
            acidity: 4.2,
            alcohol: 1.4,
            body: 3.0,
            tannin: 2.4,
            finish: 3.4
          ),
          defaultWineTaste: DefaultWineTaste(
            sweetness: 2.4,
            acidity: 4.3,
            body: 3.3,
            tannin: 1.4
          ),
          memo: "test"
        ),
        NoteCardData(
          id: 1,
          noteDate: "2023.10.11",
          wineType: .port,
          wineName: "test",
          region: "test",
          star: 3.0,
          color: Color.blue,
          buyAgain: true,
          varietal: "test",
          officialAlcohol: 24.0,
          price: 5,
          smellKeywordList: ["test"],
          myWineTaste: MyWineTaste(
            sweetness: 3.0,
            acidity: 4.2,
            alcohol: 1.4,
            body: 3.0,
            tannin: 2.4,
            finish: 3.4
          ),
          defaultWineTaste: DefaultWineTaste(
            sweetness: 2.4,
            acidity: 4.3,
            body: 3.3,
            tannin: 1.4
          ),
          memo: "test"
        )
      ]
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedNoteCard(NoteCardData)
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}
