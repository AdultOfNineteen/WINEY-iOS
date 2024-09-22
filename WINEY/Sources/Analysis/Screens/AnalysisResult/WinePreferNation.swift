//
//  WinePreferNation.swift
//  Winey
//
//  Created by 정도현 on 2023/09/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//


import ComposableArchitecture
import Foundation

public struct WinePreferNationData: Equatable, Identifiable {
  public var id: String {
    self.nationName
  }
  var nationName: String
  var count: Int
}

@Reducer
public struct WinePreferNation {
  
  @ObservableState
  public struct State: Equatable {
    let titleName = "선호 국가"
    let winePreferNationList: IdentifiedArrayOf<WinePreferNationData>
    let countSum: Int
    var rankDict: [String: Int] = [:]
    
    public init(preferNationList: [TopCountry]) {
      winePreferNationList = IdentifiedArrayOf(
        uniqueElements:
          (preferNationList.indices).map {
            WinePreferNationData(
              nationName: preferNationList[$0].country,
              count: preferNationList[$0].count
            )
          }
      )
      countSum = winePreferNationList.reduce(0){ $0 + $1.count }
      
      for (index, country) in preferNationList.sorted(by: { $0.count > $1.count }).enumerated() {
        rankDict[country.country] = index
      }
    }
  }
  
  public enum Action {
    // MARK: - User Action
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      default: return .none
      }
    }
  }
}
