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
          wineBackgroundComponent: viewStore.noteCardData.wineType.backgroundColor
        )
        
        VStack(spacing: 0) {
          HStack(spacing: 4) {
            Text(viewStore.noteCardData.wineType.typeName)
              .wineyFont(.display2)
            
            WineyAsset.Assets.star1.swiftUIImage
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(height: 13)
              .offset(y: -4)
            
            Spacer()
          }
          
          Spacer()
          
          viewStore.noteCardData.wineType.illustImage
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
                ).opacity(0.7)
            )
        )
      }
      
      Spacer()
        .frame(height: 10)
      
      // MARK: Wine Description
      VStack(spacing: 2) {
        HStack {
          Text(viewStore.noteCardData.wineName)
            .lineLimit(1)
            .wineyFont(.captionB1)
          
          Spacer()
        }
        
        HStack {
          HStack(spacing: 0) {
            Text(viewStore.noteCardData.region)
            Text(" / ")
            Text(viewStore.noteCardData.star.description)
            Text("점")
          }
          .wineyFont(.captionM2)
          .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
          
          Spacer()
        }
      }
      .frame(width: UIScreen.main.bounds.width / 2 - 24 - 15)
    }
    .onTapGesture {
      viewStore.send(.noteCardTapped)
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
        .frame(width: 90, height: 90)
        .offset(x: 10, y: 20)
        .blur(radius: 20)
      
      // for Blur
      RoundedRectangle(cornerRadius: 10)
        .foregroundColor(Color(red: 63/255, green: 63/255, blue: 63/255).opacity(0.4))
    }
    .frame(width: UIScreen.main.bounds.width / 2 - 24 - 15, height: 163)
  }
}


struct NoteCardView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color.black
      
      NoteCardView(
        store: Store(
          initialState: NoteCard.State.init(
            index: 0,
            noteCardData:
              NoteCardData(
                id: 0,
                noteDate: "2023.10.11",
                wineType: WineType.red,
                wineName: "test",
                region: "test",
                star: 1,
                color: Color.blue,
                buyAgain: true,
                varietal: "test",
                officialAlcohol: 24.0,
                price: 5,
                smellKeywordList: ["test"],
                myWineTaste: MyWineTaste(
                  sweetness: 3.0,
                  acidity: 4.2,
                  alcohol: 1.4,
                  body: 3.0,
                  tannin: 2.4,
                  finish: 3.4
                ),
                defaultWineTaste: DefaultWineTaste(
                  sweetness: 2.4,
                  acidity: 4.3,
                  body: 3.3,
                  tannin: 1.4
                ),
                memo: "test"
              )
          ), reducer: {
            NoteCard()
          })
      )
    }
  }
}
