//
//  NoteCard.swift
//  Winey
//
//  Created by 정도현 on 10/19/23.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

struct NoteCardView: View {
  private let store: StoreOf<NoteCard>
  @ObservedObject var viewStore: ViewStoreOf<NoteCard>
  
  public init(store: StoreOf<NoteCard>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  var body: some View {
    VStack(spacing: 0) {
      ZStack {
        WineNoteCardBackground(
          wineBackgroundComponent: viewStore.noteCardData.wineData.wineType.backgroundColor
        )
        
        VStack(spacing: 0) {
          HStack(spacing: 4) {
            Text(viewStore.noteCardData.wineData.wineType.typeName)
              .wineyFont(.display2)
            
            WineyAsset.Assets.star1.swiftUIImage
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(height: 13)
              .offset(y: -4)
            
            Spacer()
          }
          
          Spacer()
          
          viewStore.noteCardData.wineData.wineType.illustImage
            .resizable()
            .aspectRatio(contentMode: .fit)
        }
        .padding(.horizontal, 19)
        .padding(.top, 10)
        .padding(.bottom, 16)
        .frame(width: UIScreen.main.bounds.width / 2 - 24 - 15, height: 163)
        .background(
          RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.clear)
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(
                  LinearGradient(
                    colors: [
                      Color(red: 150/255, green: 113/255, blue: 1),
                      Color(red: 150/255, green: 113/255, blue: 1).opacity(0.2)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                  )
                )
            )
        )
      }
      
      Spacer()
        .frame(height: 10)
      
      // MARK: Wine Description
      VStack(spacing: 2) {
        HStack {
          Text(viewStore.noteCardData.wineData.wineName)
            .lineLimit(1)
            .wineyFont(.captionB1)
          
          Spacer()
        }
        
        HStack {
          HStack(spacing: 0) {
            Text(viewStore.noteCardData.wineData.nationalAnthems)
            Text(" / ")
            Text(viewStore.noteCardData.rating.description)
            Text("점")
          }
          .wineyFont(.captionM2)
          .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
          
          Spacer()
        }
      }
      .frame(width: UIScreen.main.bounds.width / 2 - 24 - 15)
    }
  }
}

public struct WineNoteCardBackground: View {
  var wineBackgroundComponent: WineBackgroundColor
  
  public var body: some View {
    ZStack {
      Circle()
        .fill(
          LinearGradient(
            gradient: Gradient(
              colors: [wineBackgroundComponent.firstCircleStart, wineBackgroundComponent.firstCircleEnd.opacity(0)]
            ),
            startPoint: .top, endPoint: .bottom
          )
        )
        .frame(width: 70, height: 70)
        .offset(x: -20, y: -30)
        .blur(radius: 20)
      
      Circle()
        .fill(
          wineBackgroundComponent.secondCircle
        )
        .frame(width: 100, height: 100)
        .offset(x: 10, y: 20)
        .blur(radius: 20)
      
      // for Blur
      RoundedRectangle(cornerRadius: 10)
        .foregroundColor(.white.opacity(0.1))
    }
    .frame(width: UIScreen.main.bounds.width / 2 - 24 - 15, height: 163)
  }
}


struct NoteCardView_Previews: PreviewProvider {
  static var previews: some View {
    NoteCardView(
      store: Store(
        initialState: NoteCard.State.init(
          index: 0,
          noteCardData: NoteCardData(
            id: 0,
            vintage: 10,
            officalAlcohol: 34.2,
            price: 9,
            color: "RED",
            sweetness: 1,
            acidity: 2,
            alcohol: 3,
            body: 2,
            tannin: 4,
            finish: 3,
            memo: "test",
            buyAgain: true,
            rating: 4,
            smellKeywordList: ["test"],
            wineData: WineCardData(
              id: 0,
              wineType: .red,
              wineName: "test",
              nationalAnthems: "test",
              varities: "test",
              purchasePrice: 5.4
            )
          )
        ), reducer: {
          NoteCard()
        })
    )
  }
}
