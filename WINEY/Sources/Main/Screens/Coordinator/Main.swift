//
//  Main.swift
//  WINEY
//
//  Created by 박혜운 on 9/17/24.
//

import ComposableArchitecture

@Reducer
public struct Main {
  @ObservableState
  public struct State: Equatable {
    
    public var tooltipState: Bool = true
    
    public var wineCardListState: WineCardCarousel.State = .init()
    public var wineTipListState: TipCardList.State = .init(isShowNavigationBar: false, searchPage: 0, searchSize: 2)
    
    @Presents var destination: MainDestination.State?
  }
  
  public enum Action {
    // MARK: - User Action
    case tappedAnalysisButton
    case viewScroll
    case tappedTipDetailButton
    
    // MARK: - Inner Business Action
    
    // MARK: - Inner SetState Action
    
    // MARK: - Child Action
    case scrollWine(WineCardCarousel.Action)
    case wineTipList(TipCardList.Action)
    
    case destination(PresentationAction<MainDestination.Action>)
    case tabDelegate(TabNavigationDelegate)
    
    public enum TabNavigationDelegate {
      case analysis
      case tipCardList
      case detailWine(id: Int, data: RecommendWineData)
    }
  }
  
  @Dependency(\.wine) var wineService
  
  public var body: some Reducer<State, Action> {
    Scope(state: \.wineCardListState, action: \.scrollWine) {
      WineCardCarousel()
    }
    
    Scope(state: \.wineTipListState, action: \.wineTipList) {
      TipCardList()
    }
    
    destinationReducer
    
    pathReducer
    
    Reduce<State, Action> { state, action in
      switch action {
        
      case .viewScroll:
        state.tooltipState = false
        return .none
        
      default:
        return .none
      }
    }
  }
}
