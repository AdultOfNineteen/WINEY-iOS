//
//  WineConfirmView.swift
//  Winey
//
//  Created by 정도현 on 12/12/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct WineConfirmView: View {
  
  private let store: StoreOf<WineConfirm>
  @ObservedObject var viewStore: ViewStoreOf<WineConfirm>
  
  public init(store: StoreOf<WineConfirm>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    ZStack {
      WineyKitAsset.mainBackground.swiftUIColor
      
      Image("noteBackground")
        .resizable()
        .scaledToFit()
      
      VStack(spacing: 0) {
        navigation()
        
        title()
        
        wineCard()
        
        Spacer()
        
        button()
      }
    }
    .ignoresSafeArea()
    .navigationBarHidden(true)
  }
}

extension WineConfirmView {
  
  @ViewBuilder
  private func navigation() -> some View {
    NavigationBar(
      leftIcon: Image("navigationBack_button"),
      leftIconButtonAction: { viewStore.send(.tappedBackButton) },
      backgroundColor: .clear
    )
    .padding(.top, 50)
  }
  
  @ViewBuilder
  private func title() -> some View {
    VStack(spacing: 6) {
      Text("해당 와인으로")
      Text("노트를 작성할까요?")
    }
    .wineyFont(.title2)
    .padding(.top, 39)
  }
  
  @ViewBuilder
  private func wineCard() -> some View {
    VStack(spacing: 0) {
      VStack(spacing: -10) {
        HStack(spacing: 3) {
          Text(viewStore.wineData.type)
            .wineyFont(.cardTitle)
          
          WineyAsset.Assets.star1.swiftUIImage
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 13)
            .offset(y: -2)
          
          Spacer()
        }
        .padding(.leading, 19)
        .padding(.top, 14)
        
        WineyAsset.Assets.redIllust.swiftUIImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding(.bottom, 4)
      }
      .frame(width: 156, height: 163)
      .background(
        RoundedRectangle(cornerRadius: 10)
          .fill(Color(red: 63/255, green: 63/255, blue: 63/255).opacity(0.4))
          .overlay(
            RoundedRectangle(cornerRadius: 10)
              .stroke(
                LinearGradient(
                  colors: [.white, .white.opacity(0.2)],
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                ),
                style: .init(lineWidth: 1)
              )
          )
      )
      
      VStack(spacing: 6) {
        Text(viewStore.wineData.name)
          .wineyFont(.bodyB1)
          .foregroundStyle(WineyKitAsset.gray50.swiftUIColor)
        Text("\(viewStore.wineData.country) / \(viewStore.wineData.varietal)")
          .wineyFont(.captionB1)
          .foregroundStyle(WineyKitAsset.gray700.swiftUIColor)
      }
      .padding(.top, 24)
    }
    .padding(.top, 59)
  }
  
  @ViewBuilder
  private func button() -> some View {
    Button {
      viewStore.send(.tappedWritingButton)
    } label: {
      Text("노트 작성하기")
        .wineyFont(.bodyB2)
        .foregroundColor(.white)
        .padding(.horizontal, 73)
        .padding(.vertical, 16)
        .background {
          RoundedRectangle(cornerRadius: 46)
            .fill(WineyKitAsset.main1.swiftUIColor)
            .shadow(color: WineyKitAsset.main1.swiftUIColor, radius: 8)
        }
    }
    .padding(.bottom, 109)
  }
}

#Preview {
  WineConfirmView(
    store: Store(
      initialState: WineConfirm.State.init(
        wineData: WineDTO(
          wineId: 1,
          type: "PORT",
          name: "mock1",
          country: "mock1",
          varietal: "프리미티보",
          sweetness: 3,
          acidity: 2,
          body: 3,
          tannins: 4,
          wineSummary: WineSummary(
            avgPrice: 1.0,
            avgSweetness: 2,
            avgAcidity: 3,
            avgBody: 2,
            avgTannins: 1
          )
        )
      ),
      reducer: {
        WineConfirm()
      }
    )
  )
}
