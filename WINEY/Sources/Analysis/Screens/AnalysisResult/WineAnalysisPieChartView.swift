//
//  WineAnalysisInitView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/19.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct WineAnalysisPieChartView: View {
  private let store: StoreOf<WineAnalysisPieChart>
  
  @State private var showGauge = false
  
  public init(store: StoreOf<WineAnalysisPieChart>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack(alignment: .top) {
      description()
      
      pieGraph()
    }
    .padding(.top, 22)
  }
}

private extension WineAnalysisPieChartView {
  
  @ViewBuilder
  private func description() -> some View {
    VStack(spacing: 2) {
      HStack(spacing: 3) {
        Text("지금까지")
          .foregroundColor(.wineyGray700)
        Text("\(store.wineDrink)개의 와인을 마셨고,")
          .foregroundColor(.wineyGray50)
      }
      
      HStack(spacing: 3) {
        Text("\(store.repurchase)개의 와인에 대해 재구매")
          .foregroundColor(.wineyGray50)
        Text("의향이 있어요!")
          .foregroundColor(.wineyGray700)
      }
    }
    .wineyFont(.captionM1)
  }
  
  @ViewBuilder
  private func pieGraph() -> some View {
    GeometryReader { geo in
      ZStack {
        WineyPieChart(preferWineTypes: store.preferWineTypes)
        
        Circle()
          .trim(from: showGauge ? 1 : 0, to: 1)
          .stroke(style: StrokeStyle(lineWidth: geo.size.width / 3.6, lineJoin: .round))
          .frame(width: geo.size.width / 3.6, height: UIScreen.main.bounds.height / 2)
          .foregroundColor(.wineyMainBackground)
          .rotationEffect(.degrees(270))
      }
      .position(x: geo.size.width / 2, y: geo.size.height / 2)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        withAnimation(.easeIn(duration: 1.0)) {
          showGauge = true
        }
      }
    }
  }
}

public struct WineAnalysisPieChartView_Previews: PreviewProvider {
  public static var previews: some View {
    WineAnalysisPieChartView(
      store: Store(
        initialState: WineAnalysisPieChart.State.init(
          wineDrink: 3,
          repurchase: 3,
          preferWineTypes: [
            TopType(type: "WHITE", percent: 75),
            TopType(type: "RED", percent: 12),
            TopType(type: "OTHER", percent: 12)
          ]
        ),
        reducer: {
          WineAnalysisPieChart()
        }
      )
    )
  }
}
