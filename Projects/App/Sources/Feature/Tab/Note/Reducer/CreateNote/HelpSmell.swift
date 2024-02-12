//
//  HelpSmell.swift
//  Winey
//
//  Created by 정도현 on 1/18/24.
//  Copyright © 2024 Winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct HelpSmell: Reducer {
  public struct State: Equatable {
    public var smellKeywordList: SmellKeyWordDTO = SmellKeyWordDTO(
      smellKeywordList: [
        // RED
        "카베르네 소비뇽": ["계피", "고추", "초콜릿", "나무"],
        "메를로": ["딸기", "체리", "라즈베리", "오렌지", "자두", "장미", "초콜릿"],
        "피노 누아": ["딸기", "체리", "나무", "흙", "버섯"],
        "시라" : ["블랙베리, 오렌지, 자두", "후추"],
        "진판델" : ["라즈베리", "블랙체리", "초콜릿", "후추"],
        "가메" : ["딸기", "체리", "자두", "꽃", "계피"],
        "그르나슈" : ["자두", "흙", "커피", "후추", "매운향"],
        "산지오배제" : ["딸기", "체리", "블랙베리", "허브", "흙", "담배", "연기 매운향"],
        "템프라니오" : ["나무", "흙", "버섯"],
        
        // WHITE
        "사르도네" : ["레몬", "배", "사과", "파인애플", "멜론", "바닐라"],
        "소비뇽블랑" : ["레몬", "자몽", "허브향", "풀향", "연기", "돌"],
        "슈냉 블랑" : ["레몬", "배", "복숭아", "멜론", "샐러리"],
        "게뷔르츠트레미너" : ["리치", "패션후르츠", "장미"],
        "리스링" : ["사과", "살구", "복숭아", "꿀"],
        "세미용" : ["레몬", "풀", "버터", "땅콩"],
        "비오니에" : ["살구", "꽃"]
      ],
      size: 16
    )
    
    public var smellList: IdentifiedArrayOf<SmellList.State> = []
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedBackButton
  
    // MARK: - Inner Business Action
    case _viewWillAppear
    
    // MARK: - Inner SetState Action
    case _setData(SmellKeyWordDTO)
    case _failureSocialNetworking(Error) // 후에 경고창 처리
    
    // MARK: - Child Action
    case smellList(id: String, action: SmellList.Action)
  }
  
  @Dependency(\.note) var noteService
  
  public var body: some ReducerOf<Self> {
    
    Reduce { state, action in
      switch action {
      case ._viewWillAppear:
        for smell in state.smellKeywordList.smellKeywordList.keys.sorted() {
          state.smellList.append(SmellList.State(title: smell, list: state.smellKeywordList.smellKeywordList[smell] ?? []))
        }
        return .none
//        return .run(operation: { send in
//          switch await noteService.smellKeywords() {
//          case let .success(dto):
//            await send(._setData(dto))
//          case let .failure(error):
//            await send(._failureSocialNetworking(error))
//          }
//        })
        
      case let ._setData(data):
        state.smellKeywordList = data
        return .none
        
      default:
        return .none
      }
    }
    .forEach(\.smellList, action: /HelpSmell.Action.smellList) {
      SmellList()
    }
  }
}
