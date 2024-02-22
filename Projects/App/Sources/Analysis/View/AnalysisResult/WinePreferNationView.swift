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
  @ObservedObject var viewStore: ViewStoreOf<WinePreferNation>
  
  public init(store: StoreOf<WinePreferNation>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      WineAnalysisTitle(title: viewStore.titleName)
        .padding(.top, 66)
      
      HStack {
        Spacer()
        
        ForEach(viewStore.winePreferNationList) { wine in
          WineBottle(
            nationName: wine.nationName,
            count: wine.count,
            rank: wine.id
          )
          
          if wine.id < viewStore.winePreferNationList.count - 1 {
            Spacer()
          }
        }
        
        Spacer()
      }
      .frame(height: 324)
      
      Spacer()
    }
  }
}

public struct WineBottle: View {
  @State var countAnimation = 0
  
  public var nationName: String
  public var count: Int
  public var rank: Int
  
  public var body: some View {
    ZStack(alignment: .center) {
      WineyAsset.Assets.wineBottle.swiftUIImage
      
      VStack(spacing: 0) {
        Spacer()
        
        Rectangle()
          .fill(
            rank == 1 ?
            LinearGradient(
              colors: [
                WineyKitAsset.main1.swiftUIColor,
                WineyKitAsset.main2.swiftUIColor
              ],
              startPoint: .top,
              endPoint: .bottom) :
              LinearGradient(
                colors: [
                  WineyKitAsset.main1.swiftUIColor
                ],
                startPoint: .top,
                endPoint: .bottom)
          )
          .padding(.horizontal, 6)
          .frame(width: 53, height: CGFloat(countAnimation * 40))
          .padding(.bottom, 16)
        
        Text("\(nationName)(\(count)회)")
          .wineyFont(.bodyB2)
          .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
          .multilineTextAlignment(.center)
      }
      .offset(y: 26)
      .frame(height: 208)
    }
    .onAppear {
      withAnimation(.easeIn(duration: 1.0)) {
        countAnimation = count
      }
    }
  }
}

public struct WineAnalysisTitle: View {
  public var title: String
  
  public var body: some View {
    HStack(spacing: 1) {
      Circle()
        .frame(width: 7)
        .offset(y: -14)
        .foregroundColor(WineyKitAsset.main2.swiftUIColor)
      
      Text(title)
        .wineyFont(.title2)
        .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
    }
  }
}

public struct WinePreferNationView_Previews: PreviewProvider {
  public static var previews: some View {
    WinePreferNationView(
      store: Store(
        initialState:
          WinePreferNation.State.init(
            preferNationList: []),
        reducer: {
          WinePreferNation()
        }
      )
    )
  }
}
