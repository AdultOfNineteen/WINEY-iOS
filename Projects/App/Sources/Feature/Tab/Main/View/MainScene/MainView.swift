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
          VStack(alignment: .leading) {
            
            // MARK: TOP Description
            VStack(alignment: .leading, spacing: 22) {
              Text("WINEY")
                .wineyFont(.wineyTitle)
                .foregroundColor(WineyKitAsset.gray400.swiftUIColor)
                .padding(.top, 17)
              
              VStack(alignment: .leading, spacing: 12) {
                Text("오늘의 와인")
                  .wineyFont(.title1)
                  .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
                
                Text("매일 나의 취향에 맞는 와인을 추천드려요!")
                  .wineyFont(.captionM1)
                  .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
              }
            }
            
            // TODO: WINE CARD VIEW
            WineCard(
              wineType: "RED",
              wineName: "캄포 마리나 프리미이도 디 만두리아",
              nationalAnthems: "이탈리아",
              varities: "프리미티보",
              purchasePrice: 8.8
            )
            .frame(width: 282, height: 363)
            .padding(.top, 25)
            .padding(.bottom, 35)
            
            
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
            
            Spacer()
            
            
            // TODO: TIP Card
            
          }
        }
        .padding(.horizontal, 24)
      }
    }
  }
}
