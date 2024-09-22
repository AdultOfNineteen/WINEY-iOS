//
//  HelpSmell.swift
//  Winey
//
//  Created by 정도현 on 1/18/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct HelpSmell {
  
  @ObservableState
  public struct State: Equatable {
    public var redList: IdentifiedArrayOf<SmellList.State> = [
      SmellList.State(wineName: "카베르네 소비뇽", smellList: ["계피", "고추", "초콜릿", "나무"], type: .red),
      SmellList.State(wineName: "메를로", smellList: ["딸기", "체리", "라즈베리", "오렌지", "자두", "장미", "초콜릿"], type: .red),
      SmellList.State(wineName: "피노 누아", smellList: ["딸기", "체리", "나무", "흙", "버섯"], type: .red),
      SmellList.State(wineName: "시라", smellList: ["블랙베리", "오렌지", "자두", "후추"], type: .red),
      SmellList.State(wineName: "진판델", smellList: ["라즈베리", "블랙체리", "초콜릿", "후추"], type: .red),
      SmellList.State(wineName: "가메", smellList: ["딸기", "체리", "자두", "꽃", "계피"], type: .red),
      SmellList.State(wineName: "그르나슈", smellList: ["자두", "흙", "커피", "후추", "매운향"], type: .red),
      SmellList.State(wineName: "산지오배제", smellList: ["딸기", "체리", "블랙베리", "허브", "흙", "담배", "연기 매운향"], type: .red),
      SmellList.State(wineName: "템프라니오", smellList: ["나무", "흙", "버섯"], type: .red)
    ]
    
    public var whiteList: IdentifiedArrayOf<SmellList.State> = [
      SmellList.State(wineName: "사르도네", smellList: ["레몬", "배", "사과", "파인애플", "멜론", "바닐라"], type: .white),
      SmellList.State(wineName: "소비뇽블랑", smellList: ["레몬", "자몽", "허브향", "풀향", "연기", "돌"], type: .white),
      SmellList.State(wineName: "슈냉 블랑", smellList: ["레몬", "배", "복숭아", "멜론", "샐러리"], type: .white),
      SmellList.State(wineName: "게뷔르츠트레미너", smellList: ["리치", "패션후르츠", "장미"], type: .white),
      SmellList.State(wineName: "리스링", smellList: ["사과", "살구", "복숭아", "꿀"], type: .white),
      SmellList.State(wineName: "세미용", smellList: ["레몬", "풀", "버터", "땅콩"], type: .white),
      SmellList.State(wineName: "비오니에", smellList: ["살구", "꽃"], type: .white)
    ]
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
//    case redList(id: String, action: SmellList.Action)
//    case whiteList(id: String, action: SmellList.Action)
    case redList(IdentifiedActionOf<SmellList>)
    case whiteList(IdentifiedActionOf<SmellList>)
  }
  
  @Dependency(\.note) var noteService
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      default:
        return .none
      }
    }
    .forEach(\.redList, action: \.redList) {
      SmellList()
    }
    .forEach(\.whiteList, action: \.whiteList) {
      SmellList()
    }
  }
}
