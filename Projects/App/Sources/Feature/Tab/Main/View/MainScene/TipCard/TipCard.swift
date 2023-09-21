//
//  TipCard.swift
//  Winey
//
//  Created by 정도현 on 2023/09/21.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation
import SwiftUI
import WineyKit

public struct CardInfo: Identifiable, Equatable {
  public let id: Int
  public let tipCardImage: Image
  
  public init(id: Int, tipCardImage: Image) {
    self.id = id
    self.tipCardImage = tipCardImage
  }
}


public struct TipCard: Reducer {
  public struct State: Equatable {
    var cardList: IdentifiedArrayOf<CardInfo>
    
    public init() {
      self.cardList = [
        CardInfo(id: 0, tipCardImage: WineyAsset.Assets.tipCard.swiftUIImage),
        CardInfo(id: 1, tipCardImage: WineyAsset.Assets.tipCard.swiftUIImage),
        CardInfo(id: 2, tipCardImage: WineyAsset.Assets.tipCard.swiftUIImage)
      ]
    }
  }
  
  public enum Action {
    // MARK: - User Action
    case tapCard(Int)
    case tappedBackButton
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case let .tapCard(id):
        print("tab card \(id)")
        return .none
        
      default:
        return .none
      }
    }
  }
}
