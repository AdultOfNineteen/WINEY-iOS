//
//  MainView.swift
//  WINEY
//
//  Created by 박혜운 on 9/17/24.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
  @Bindable var store: StoreOf<Main>
  
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      Button {
        store.send(.tappedAnalysisButton)
      } label: {
        Text("분석하기 버튼")
      }
      .navigationBarBackButtonHidden()
    } destination: { store in
      switch store.state {
      case .analysis:
        if let store = store.scope(state: \.analysis, action: \.analysis) {
          WineAnalysisView(store: store)
        }
      case .loading:
        if let store = store.scope(state: \.loading, action: \.loading) {
          WineAnalysisLoadingView(store: store)
        }
      case .result:
        if let store = store.scope(state: \.result, action: \.result) {
          WineAnalysisResultView(store: store)
        }
      }
    }
  }
}

#Preview {
  MainView(
    store: .init(
      initialState: .init(),
      reducer: {
        Main()
      }
    )
  )
}

