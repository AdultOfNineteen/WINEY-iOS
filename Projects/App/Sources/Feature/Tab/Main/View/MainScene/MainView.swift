//
//  MainView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct MainView: View {
  private let store: Store<MainState, MainAction>
  
  public init(store: Store<MainState, MainAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      ScrollView {
        GeometryReader { _ in
          VStack(alignment: .leading, spacing: 0) {
            
            // MARK: TOP Description
            VStack(alignment: .leading, spacing: 22) {
              HStack {
                Text("WINEY")
                  .wineyFont(.display2)
                  .foregroundColor(WineyKitAsset.gray400.swiftUIColor)
                  .padding(.top, 17)
                
                Spacer()
                
                MainAnalysisButton(
                  title: "분석하기",
                  action: {}
                )
              }
              
              VStack(alignment: .leading, spacing: 12) {
                Text("오늘의 와인")
                  .wineyFont(.title1)
                  .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
                
                Text("매일 나의 취향에 맞는 와인을 추천드려요!")
                  .wineyFont(.captionM1)
                  .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
              }
            }
            .padding(.horizontal, 24)
            
            // TODO: WINE CARD VIEW
            WineCardListView(
              store: self.store.scope(
                state: \.wineCardListState,
                action: MainAction.wineCardListAction
              )
            )
            .padding(.top, 24)
            .padding(.bottom, 29.5)
            .padding(.leading, 24)
            
            // MARK: Bottom TIP
            HStack(spacing: 0) {
              Group {
                Text("와인 초보를 위한 ")
                Text("TIP")
                  .foregroundColor(WineyKitAsset.main2.swiftUIColor)
                Text(" !")
              }
              .wineyFont(.title2)
              
              Spacer()
              
              Image(systemName: "chevron.right")
            }
            .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
            .padding(.horizontal, 24)
            
            // TODO: TIP Card
            
          }
        }
      }
      .background(Color(red: 31/255, green: 33/255, blue: 38/255))
    }
  }
}
