//
//  MainView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct MainView: View {
  private let store: StoreOf<Main>
  @ObservedObject var viewStore: ViewStoreOf<Main>
  let columns = [GridItem(.flexible()), GridItem(.flexible())]
  
  public init(store: StoreOf<Main>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    GeometryReader { _ in
      VStack(alignment: .leading, spacing: 0) {
        // MARK: HEADER
        ZStack {
          HStack {
            Text("WINEY")
              .wineyFont(.display2)
              .foregroundColor(WineyKitAsset.gray400.swiftUIColor)
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 45)
              .fill(WineyKitAsset.main2.swiftUIColor)
              .frame(width: 95, height: 33)
              .shadow(color: WineyKitAsset.main2.swiftUIColor, radius: 7)
              .overlay(
                MainAnalysisButton(
                  title: "분석하기", icon: WineyKitAsset.analysisIcon.swiftUIImage,
                  action: {
                    viewStore.send(.tappedAnalysisButton)
                  }
                )
              )
          }
          
          HStack {
            Spacer()
            
            MainTooltip(content: "나에게 맞는 와인을 분석해줘요!")
              .opacity(viewStore.tooltipState ? 1.0 : 0.0)
              .animation(.easeOut(duration: 1.0), value: viewStore.tooltipState)
              .offset(y: 45)
          }
        }
        .padding(.top, 17)
        .padding(.bottom, 10)
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
        
        ScrollView {
          LazyVStack(spacing: 0) {
            HStack {
              VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 0) {
                  Text("오늘의 와인")
                    .wineyFont(.title1)
                    .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
                  
                  WineyAsset.Assets.wineIcon.swiftUIImage
                    .resizable()
                    .frame(width: 30, height: 30)
                }
                
                Text("매일 나의 취향에 맞는 와인을 추천드려요!")
                  .wineyFont(.captionM1)
                  .foregroundColor(WineyKitAsset.gray600.swiftUIColor)
              }
              
              Spacer()
            }
            .padding(.top, 10)
            .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
            
            IfLetStore(
              self.store.scope(
                state: \.wineCardListState,
                action: Main.Action.wineCardScroll
              )
            ) {
              WineCardScrollView(store: $0)
                .padding(.top, 20)
                .padding(.bottom, 25.5)
                .padding(.leading, 24)
            }
            
            // MARK: Bottom TIP
            HStack(spacing: 0) {
              Group {
                Text("와인 초보를 위한 ")
                Text("TIP")
                  .foregroundColor(WineyKitAsset.main2.swiftUIColor)
                Text(" !")
              }
              .wineyFont(.title2)
              
              Spacer()
              
              WineyAsset.Assets.icArrowRight.swiftUIImage
                .onTapGesture {
                  viewStore.send(.tappedTipArrow)
                }
            }
            .foregroundColor(WineyKitAsset.gray50.swiftUIColor)
            .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
            
            IfLetStore(
              self.store.scope(
                state: \.tipCardState,
                action: Main.Action.tipCard
              )
            ) { _ in
              
              LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewStore.tipCardState!.cardList.prefix(2)) { card in
                  Button(action: {
                    viewStore.send(.tipCard(.tapCard(card.id)))
                  }, label: {
                    card.tipCardImage
                  })
                }
              }
              .padding(.top, 25)
              .padding(.bottom, 50)
              .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
            }
          }
          .padding(.bottom, 30)
        }
        .simultaneousGesture(
          DragGesture().onChanged({ value in
            viewStore.send(.userScroll)
          })
        )
      }
      .onAppear {
        viewStore.send(._viewWillAppear)
      }
    }
    .background(WineyKitAsset.mainBackground.swiftUIColor)
    .navigationViewStyle(StackNavigationViewStyle())
    .navigationBarHidden(true)
  }
}


struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView(store: StoreOf<Main>(
      initialState: .init(
        tooltipState: true
      ),
      reducer: {
        Main()
          .dependency(\.wine, .mock)
      })
    )
  }
}
