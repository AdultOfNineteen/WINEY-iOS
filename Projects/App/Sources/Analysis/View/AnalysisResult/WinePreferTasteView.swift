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
  @ObservedObject var viewStore: ViewStoreOf<WinePreferTaste>
  
  public init(store: StoreOf<WinePreferTaste>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      WineAnalysisCategoryTitle(title: viewStore.title)
        .padding(.top, 66)
      
      HexagonGraphDataView(store: store)
      
      Spacer()
    }
  }
}

public struct HexagonGraphDataView: View {
  private let store: StoreOf<WinePreferTaste>
  @ObservedObject var viewStore: ViewStoreOf<WinePreferTaste>
  
  public init(store: StoreOf<WinePreferTaste>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    ZStack {
      HexagonBackgroundView(topTaste: viewStore.topTaste)
      
      HexagonDataView(
        store: store,
        hexagonSize: UIScreen.main.bounds.width / 22
      )
    }
    .frame(height: 324)
    .padding(.top, 16)
  }
}

public struct HexagonDataView: View {
  private let store: StoreOf<WinePreferTaste>
  @ObservedObject var viewStore: ViewStoreOf<WinePreferTaste>
  
  public var hexagonSize: CGFloat
  
  public init(store: StoreOf<WinePreferTaste>, hexagonSize: CGFloat) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
    self.hexagonSize = hexagonSize
  }
  
  public var body: some View {
    GeometryReader { geometry in
      Path { path in
        let size: CGFloat = hexagonSize
        let sideLength = size / 2 * sqrt(3)
        
        let centerX = geometry.size.width / 2
        let centerY = geometry.size.height / 2
        
        let points: [CGPoint] = [
          CGPoint(x: centerX, y: centerY - size * viewStore.sweet.value),
          CGPoint(x: centerX + sideLength * viewStore.remain.value, y: centerY - size / 2 * viewStore.remain.value),
          CGPoint(x: centerX + sideLength * viewStore.alcohol.value, y: centerY + size / 2 * viewStore.alcohol.value),
          CGPoint(x: centerX, y: centerY + size * viewStore.tannin.value),
          CGPoint(x: centerX - sideLength * viewStore.wineBody.value, y: centerY + size / 2 * viewStore.wineBody.value),
          CGPoint(x: centerX - sideLength * viewStore.acid.value, y: centerY - size / 2 * viewStore.acid.value)
        ]
        path.addLines(points)
      }
      .fill(WineyKitAsset.main3.swiftUIColor.opacity(0.3))
      .scaleEffect(viewStore.animation)
      .onAppear {
        viewStore.send(._onAppear, animation: .easeIn(duration: 1.0))
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
  let width = UIScreen.main.bounds.width
  
  public var body: some View {
    ZStack(alignment: .center) {
      HexagonView(
        hexagonSize: width / 22,
        color: WineyKitAsset.gray900.swiftUIColor.opacity(0.5),
        lineWidth: 1.0
      )
      
      ForEach(1..<5) { i in
        HexagonView(
          hexagonSize: width / 22 * CGFloat(i + 1),
          color: WineyKitAsset.gray900.swiftUIColor.opacity(0.5),
          lineWidth: 1.0
        )
      }
      
      HexagonView(
        hexagonSize: width / 22 * 7,
        color: WineyKitAsset.gray900.swiftUIColor.opacity(0.8),
        lineWidth: 1.5
      )
      
      Text("당도")
        .offset(y: -width / 3 - 10)
        .foregroundStyle(topTaste == "당도" ? .white : WineyKitAsset.gray600.swiftUIColor)
      Text("산도")
        .offset(x: -width / 3, y: -width / 5 + 15)
        .foregroundStyle(topTaste == "산도" ? .white : WineyKitAsset.gray600.swiftUIColor)
      Text("여운")
        .offset(x: width / 3, y: -width / 5 + 15)
        .foregroundStyle(topTaste == "여운" ? .white : WineyKitAsset.gray600.swiftUIColor)
      Text("바디")
        .offset(x: -width / 3, y: width / 5 - 15)
        .foregroundStyle(topTaste == "바디" ? .white : WineyKitAsset.gray600.swiftUIColor)
      Text("알코올")
        .offset(x: width / 3 + 5, y: width / 5 - 15)
        .foregroundStyle(topTaste == "알코올" ? .white : WineyKitAsset.gray600.swiftUIColor)
      Text("탄닌")
        .offset(y: width / 3 + 10)
        .foregroundStyle(topTaste == "탄닌" ? .white : WineyKitAsset.gray600.swiftUIColor)
    }
    .wineyFont(.captionB1)
    .frame(height: 324)
  }
}
