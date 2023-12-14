//
//  WineSearch.swift
//  Winey
//
//  Created by 정도현 on 11/7/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct WineSearch: Reducer {
  public struct State: Equatable {
    public var userSearch: String = ""
    
    public var wineCards: IdentifiedArrayOf<WineCardData> = [
      WineCardData(
        id: 0,
        wineType: .red,
        name: "캄포마리나",
        country: "이탈리아",
        varietal: "test",
        sweetness: 1,
        acidity: 2,
        body: 3,
        tannins: 4,
        wineSummary: WineSummary(
          avgPrice: 1,
          avgSweetness: 2,
          avgAcidity: 3,
          avgBody: 4,
          avgTannins: 5
        )
      ),
      WineCardData(
        id: 1,
        wineType: .rose,
        name: "캄포마리나",
        country: "이탈리아",
        varietal: "test",
        sweetness: 1,
        acidity: 2,
        body: 3,
        tannins: 4,
        wineSummary: WineSummary(
          avgPrice: 1,
          avgSweetness: 2,
          avgAcidity: 3,
          avgBody: 4,
          avgTannins: 5
        )
      ),
      WineCardData(
        id: 2,
        wineType: .etc,
        name: "캄포마리나",
        country: "이탈리아",
        varietal: "test",
        sweetness: 1,
        acidity: 2,
        body: 3,
        tannins: 4,
        wineSummary: WineSummary(
          avgPrice: 1,
          avgSweetness: 2,
          avgAcidity: 3,
          avgBody: 4,
          avgTannins: 5
        )
      )
    ]
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedWineCard(WineCardData)
    
    // MARK: - Inner Business Action
    case _settingSearchString(String)
    case _updateList(String)
    case _focusing
    case _unfocusing
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case let ._settingSearchString(text):
        state.userSearch = text
        return .send(._updateList(text))
        
      default:
        return .none
      }
    }
  }
}
