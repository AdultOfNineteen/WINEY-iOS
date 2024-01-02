//
//  SettingTaste.swift
//  Winey
//
//  Created by 정도현 on 11/29/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct SettingTaste: Reducer {
  public struct State: Equatable {
    public var wineId: Int
    public var officialAlcohol: Int
    public var vintage: Int
    public var price: Int
    public var color: String
    public var smellKeywordList: [String]
    
    public var sweetness: Int = 0
    public var acidity: Int = 0
    public var body: Int = 0
    public var tannin: Int = 0
    public var alcohol: Int = 0
    public var finish: Int = 0
    
    public init(wineId: Int, officialAlcohol: Int, vintage: Int, price: Int, color: String, smellKeywordList: [String]) {
      self.wineId = wineId
      self.officialAlcohol = officialAlcohol
      self.vintage = vintage
      self.price = price
      self.color = color
      self.smellKeywordList = smellKeywordList
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    case tappedNextButton
    case tappedHelpButton(wineId: Int)
  
    // MARK: - Inner Business Action
    case _moveNextPage(
      wineId: Int,
      officialAlcohol: Int,
      vintage: Int,
      price: Int,
      color: String,
      smellKeywordList: [String],
      sweetness: Int,
      acidity: Int,
      alcohol: Int,
      body: Int,
      tannin: Int,
      finish: Int
    )
    
    // MARK: - Inner SetState Action
    case _setSweetness(Int)
    case _setAcidity(Int)
    case _setBody(Int)
    case _setTannin(Int)
    case _setAlcohol(Int)
    case _setFinish(Int)

    
    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
     
      case ._setSweetness(let value):
        state.sweetness = value
        return .none
        
      case ._setAcidity(let value):
        state.acidity = value
        return .none
        
      case ._setBody(let value):
        state.body = value
        return .none
        
      case ._setTannin(let value):
        state.tannin = value
        return .none
        
      case ._setAlcohol(let value):
        state.alcohol = value
        return .none
        
      case ._setFinish(let value):
        state.finish = value
        return .none
        
      case .tappedNextButton:
        return .send(
          ._moveNextPage(
            wineId: state.wineId,
            officialAlcohol: state.officialAlcohol, 
            vintage: state.vintage,
            price: state.price,
            color: state.color,
            smellKeywordList: state.smellKeywordList, 
            sweetness: state.sweetness,
            acidity: state.acidity,
            alcohol: state.alcohol,
            body: state.body,
            tannin: state.tannin,
            finish: state.finish
          )
        )
        
      default:
        return .none
      }
    }
  }
}
