//
//  WinePreferSmellView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/18.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct WinePreferSmellView: View {
  private let store: StoreOf<WinePreferSmell>
  @ObservedObject var viewStore: ViewStoreOf<WinePreferSmell>
  
  public init(store: StoreOf<WinePreferSmell>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      WineAnalysisCategoryTitle(title: viewStore.title)
        .padding(.top, 66)
      
      smellContents()
        .frame(maxHeight: .infinity)
        .padding(.bottom, 60)
    }
  }
}

extension WinePreferSmellView {
  
  @ViewBuilder
  private func smellContents() -> some View {
    GeometryReader { geo in
      ZStack {
        background()
        
        if viewStore.topSevenSmells.isEmpty {
          Text("선호하는 향이 없어요 :(")
            .wineyFont(.title2)
            .foregroundStyle(WineyKitAsset.gray600.swiftUIColor)
        } else {
          ForEach(viewStore.topSevenSmells.indices, id: \.self) { index in
            Text(viewStore.topSevenSmells[index].smell)
              .wineyFont(index == 0 ? .title2 : .bodyB1)
              .foregroundColor(
                index == 0 ? WineyKitAsset.main3.swiftUIColor :
                  index == 2 ? WineyKitAsset.gray300.swiftUIColor : WineyKitAsset.gray600.swiftUIColor
              )
              .offset(x: getGrid(index: index, geo: geo).xGrid, y: getGrid(index: index, geo: geo).yGrid)
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .opacity(viewStore.opacity)
      .padding(.top, 16)
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      .onAppear {
        viewStore.send(._onAppear, animation: .easeIn(duration: 1.0))
      }
    }
  }
  
  @ViewBuilder
  private func background() -> some View {
    ZStack {
      Circle()
        .fill(
          RadialGradient(
            gradient: Gradient(stops: [
              .init(color: Color(red: 81/225, green: 35/225, blue: 223/225).opacity(0.5), location: 0.0),
              .init(color: Color(red: 81/225, green: 35/225, blue: 223/225).opacity(0.2), location: 0.2),
              .init(color: Color(red: 34/225, green: 3/225, blue: 49/225).opacity(0.1), location: 0.7),
              .init(color: .clear, location: 1)
            ]),
            center: .center,
            startRadius: 0,
            endRadius: UIScreen.main.bounds.width / 2.5
          )
        )
    }
  }
}

extension WinePreferSmellView {
  public struct SmellGrid {
    public var xGrid: CGFloat
    public var yGrid: CGFloat
  }
  
  public func getGrid(index: Int, geo: GeometryProxy) -> SmellGrid {
    switch index {
    case 0:
      return SmellGrid(xGrid: 0, yGrid: 0)
    case 1:
      return SmellGrid(xGrid: geo.size.width / 6, yGrid: -60)
    case 2:
      return SmellGrid(xGrid: geo.size.width / 7, yGrid: 50)
    case 3:
      return SmellGrid(xGrid: -geo.size.width / 7, yGrid: 60)
    case 4:
      return SmellGrid(xGrid: -geo.size.width / 4, yGrid: -30)
    case 5:
      return SmellGrid(xGrid: geo.size.width / 3.2, yGrid: -20)
    case 6:
      return SmellGrid(xGrid: -geo.size.width / 2.8, yGrid: 30)
    default:
      return SmellGrid(xGrid: 0, yGrid: 0)
    }
  }
}
