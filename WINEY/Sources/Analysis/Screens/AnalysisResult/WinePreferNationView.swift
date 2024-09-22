//
//  WinePreferNationView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/17.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct WinePreferNationView: View {
  private let store: StoreOf<WinePreferNation>
  
  public init(store: StoreOf<WinePreferNation>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      WineAnalysisCategoryTitle(title: store.titleName)
        .padding(.top, 66)
      
      HStack {
        ForEach(store.winePreferNationList) { wine in
          WineBottle(
            nationName: wine.nationName,
            count: wine.count,
            countSum: store.countSum,
            rank: store.rankDict[wine.nationName] ?? 0
          )
          .frame(maxWidth: 100)
        }
      }
      .padding(.top, 43)
      
      Spacer()
    }
  }
}

/// 각 와인 병을 나타냅니다.
public struct WineBottle: View {
  @State var animation = 0
  
  public let nationName: String
  public let count: Int
  public let countSum: Int
  public let rank: Int
  
  public init(
    nationName: String,
    count: Int,
    countSum: Int,
    rank: Int
  ) {
    self.nationName = nationName
    self.count = count
    self.countSum = countSum
    self.rank = rank
  }
  
  public var body: some View {
    VStack(alignment: .center, spacing: 12) {
      bottleSection()
      
      Text("\(nationName)(\(count)회)")
        .wineyFont(.bodyB2)
        .foregroundColor(textColor(rank: rank))
        .multilineTextAlignment(.center)
      
      Spacer()
    }
  }
}

private extension WineBottle {
  
  @ViewBuilder
  private func bottleSection() -> some View {
    ZStack(alignment: .bottom) {
      Image(.wineBottleW)
      
      RoundedRectangle(cornerRadius: 3)
        .fill(
          rank == 0 ?
          LinearGradient(
            colors: [
              .wineyMain1,
              .wineyMain2
            ],
            startPoint: .top,
            endPoint: .bottom
          ) :
            LinearGradient(
              colors: [
                .wineyMain1
              ],
              startPoint: .top,
              endPoint: .bottom
            )
        )
        .padding(.bottom, 5)
        .frame(width: 41, height: CGFloat(animation))
    }
    .onAppear {
      withAnimation(.easeIn(duration: 1.0)) {
        animation = Int(Double(count) / Double(countSum) * 140)   /// 내부 값이 와인 병을 넘기지 않기 위해 최대 높이 140을 제한 후 비율 값을 통한 표기
      }
    }
  }
  
  /// 각 나라 순위에 해당하는 텍스트 색상을 리턴합니다.
  func textColor(rank: Int) -> Color {
    switch rank {
    case 0:
      return .wineyGray50
    case 1:
      return .wineyGray700
    case 2:
      return .wineyGray900
    default:
      return .wineyMain1
    }
  }
}

public struct WinePreferNationView_Previews: PreviewProvider {
  public static var previews: some View {
    WinePreferNationView(
      store: Store(
        initialState:
          WinePreferNation.State.init(
            preferNationList: [
              TopCountry(country: "testestestesttest", count: 11),
              TopCountry(country: "test", count: 2),
              TopCountry(country: "testestets", count: 11)
            ]
          ),
        reducer: {
          WinePreferNation()
        }
      )
    )
  }
}
