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
      WineAnalysisTitle(title: viewStore.title)
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
      HexagonBackgroundView()
      
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
          CGPoint(x: centerX, y: centerY - size * viewStore.sweet),
          CGPoint(x: centerX + sideLength * viewStore.remain, y: centerY - size / 2 * viewStore.remain),
          CGPoint(x: centerX + sideLength * viewStore.alcohol, y: centerY + size / 2 * viewStore.alcohol),
          CGPoint(x: centerX, y: centerY + size * viewStore.tannin),
          CGPoint(x: centerX - sideLength * viewStore.wineBody, y: centerY + size / 2 * viewStore.wineBody),
          CGPoint(x: centerX - sideLength * viewStore.acid, y: centerY - size / 2 * viewStore.acid)
        ]
        path.addLines(points)
      }
      .fill(WineyKitAsset.main3.swiftUIColor.opacity(0.5))
      .scaleEffect(viewStore.animation)
      .onAppear {
        viewStore.send(._onAppear, animation: .easeIn(duration: 1.0))
      }
    }
  }
}


public struct HexagonView: View {
  var hexagonSize: CGFloat
  var color: Color
  var lineWidth: CGFloat
  
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
      Text("산도")
        .offset(x: -width / 3, y: -width / 5 + 15)
      Text("여운")
        .offset(x: width / 3, y: -width / 5 + 15)
      Text("바디")
        .offset(x: -width / 3, y: width / 5 - 15)
      Text("알코올")
        .offset(x: width / 3 + 5, y: width / 5 - 15)
      Text("탄닌")
        .offset(y: width / 3 + 10)
    }
    .wineyFont(.captionB1)
    .frame(height: 324)
  }
}
