//
//  WineOxagonGraphView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/18.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct WinePreferTasteView: View {
  private let store: StoreOf<WinePreferTaste>
  
  public init(store: StoreOf<WinePreferTaste>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      WineAnalysisCategoryTitle(title: store.title)
        .padding(.top, 66)
      
      hexagonGraphSection()
    }
  }
}

private extension WinePreferTasteView {
  
  @ViewBuilder
  func hexagonGraphSection() -> some View {
    ZStack(alignment: .top) {
      HexagonBackgroundView(topTaste: store.topTaste, isSparkling: store.isSparkling)
      
      hexagonDataView()
    }
  }
  
  /// 사용자 데이터에 해당하는 육각 그래프를 생성합니다.
  @ViewBuilder
  func hexagonDataView() -> some View {
    GeometryReader { geometry in
      Path { path in
        let size: CGFloat = UIScreen.main.bounds.width / 22
        let sideLength = size / 2 * sqrt(3)
        
        let centerX = geometry.size.width / 2
        let centerY = geometry.size.height / 2
        
        let points: [CGPoint] = [
          CGPoint(x: centerX, y: centerY - size * store.sweet.value),
          CGPoint(x: centerX + sideLength * store.remain.value, y: centerY - size / 2 * store.remain.value),
          CGPoint(x: centerX + sideLength * (store.isSparkling ? store.sparkling.value : store.alcohol.value), y: centerY + size / 2 * (store.isSparkling ? store.sparkling.value : store.alcohol.value)),
          CGPoint(x: centerX, y: centerY + size * store.tannin.value),
          CGPoint(x: centerX - sideLength * store.wineBody.value, y: centerY + size / 2 * store.wineBody.value),
          CGPoint(x: centerX - sideLength * store.acid.value, y: centerY - size / 2 * store.acid.value)
        ]
        path.addLines(points)
      }
      .fill(.wineyMain3.opacity(0.3))
      .scaleEffect(store.animation)
      .onAppear {
        store.send(._onAppear, animation: .easeIn(duration: 1.0))
      }
    }
  }
}

public struct HexagonView: View {
  let hexagonSize: CGFloat
  let color: Color
  let lineWidth: CGFloat
  
  public var body: some View {
    GeometryReader { geometry in
      Path { path in
        let size: CGFloat = hexagonSize
        let sideLength = size / 2 * sqrt(3)
        
        let centerX = geometry.size.width / 2
        let centerY = geometry.size.height / 2
        
        let points: [CGPoint] = [
          CGPoint(x: centerX, y: centerY - size),
          CGPoint(x: centerX + sideLength, y: centerY - size / 2),
          CGPoint(x: centerX + sideLength, y: centerY + size / 2),
          CGPoint(x: centerX, y: centerY + size),
          CGPoint(x: centerX - sideLength, y: centerY + size / 2),
          CGPoint(x: centerX - sideLength, y: centerY - size / 2)
        ]
        path.addLines(points)
        path.closeSubpath()
      }
      .stroke(color, lineWidth: lineWidth)
    }
  }
}

public struct HexagonBackgroundView: View {
  
  let topTaste: String
  let isSparkling: Bool
  let width = UIScreen.main.bounds.width
  
  public init(topTaste: String, isSparkling: Bool) {
    self.topTaste = topTaste
    self.isSparkling = isSparkling
  }
  
  public var body: some View {
    ZStack(alignment: .center) {
      HexagonView(
        hexagonSize: width / 22,
        color: .wineyGray900.opacity(0.5),
        lineWidth: 1.0
      )
      
      ForEach(1..<5) { i in
        HexagonView(
          hexagonSize: width / 22 * CGFloat(i + 1),
          color: .wineyGray900.opacity(0.5),
          lineWidth: 1.0
        )
      }
      
      HexagonView(
        hexagonSize: width / 22 * 7,
        color: .wineyGray900.opacity(0.8),
        lineWidth: 1.5
      )
      
      Text("당도")
        .offset(y: -width / 3 - 10)
        .foregroundStyle(topTaste == "당도" ? .white : .wineyGray600)
      Text("산도")
        .offset(x: -width / 3, y: -width / 5 + 15)
        .foregroundStyle(topTaste == "산도" ? .white : .wineyGray600)
      Text("여운")
        .offset(x: width / 3, y: -width / 5 + 15)
        .foregroundStyle(topTaste == "여운" ? .white : .wineyGray600)
      Text("바디")
        .offset(x: -width / 3, y: width / 5 - 15)
        .foregroundStyle(topTaste == "바디" ? .white : .wineyGray600)
      Text(isSparkling ? "탄산감" : "알코올")
        .offset(x: width / 3 + 5, y: width / 5 - 15)
        .foregroundStyle(
          isSparkling ? (topTaste == "탄산감" ? .white : .wineyGray600) : (topTaste == "알코올" ? .white : .wineyGray600)
        )
      Text("탄닌")
        .offset(y: width / 3 + 10)
        .foregroundStyle(topTaste == "탄닌" ? .white : .wineyGray600)
    }
    .wineyFont(.captionB1)
  }
}

#Preview {
  WinePreferTasteView(
    store: Store(
      initialState: WinePreferTaste.State.init(
        preferTastes:
          Taste(
            sweetness: 1, 
            acidity: 1,
            alcohol: 1,
            body: 2,
            tannin: 3,
            sparkling: 0,
            finish: 1
          ),
        isSparkling: true
      ),
      reducer: {
        WinePreferTaste()
      }
    )
  )
}
