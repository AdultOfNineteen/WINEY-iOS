//
//  MainView.swift
//  WINEY
//
//  Created by 박혜운 on 9/17/24.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

struct MainView: View {
  @Bindable var store: StoreOf<Main>
  
  var body: some View {
    content()
      .navigationBarBackButtonHidden()
      .navigationDestination(
        item: $store.scope(state: \.destination?.tipDetail, action: \.destination.tipDetail),
        destination: { store in
          TipCardDetailView(store: store)
        }
      )
      .background(.wineyMainBackground)
  }
}

private extension MainView {
  
  @ViewBuilder
  private func content() -> some View {
    VStack(alignment: .leading, spacing: 0) {
      header()
      
      ScrollView {
        LazyVStack(spacing: 0) {
          todaysWineDescription()
          
          cardScrollView()
          
          tipView()
        }
        .padding(.bottom, 106)
      }
      .simultaneousGesture(
        DragGesture().onChanged({ value in
          store.send(.viewScroll)
        })
      )
    }
  }
  
  @ViewBuilder
  private func header() -> some View {
    ZStack {
      HStack {
        Text("WINEY")
          .wineyFont(.display2)
          .foregroundColor(.wineyGray400)
        
        Spacer()
        
        RoundedRectangle(cornerRadius: 45)
          .fill(.wineyMain2)
          .frame(width: 95, height: 33)
          .shadow(color: .wineyMain2, radius: 7)
          .overlay(
            MainAnalysisButton(
              title: "분석하기", icon: Image(.analysis_iconW),
              action: {
                store.send(.tappedAnalysisButton)
              }
            )
          )
      }
      
      HStack {
        Spacer()
        
        MainTooltip(content: "나에게 맞는 와인을 분석해줘요!")
          .opacity(store.tooltipState ? 1.0 : 0.0)
          .animation(.easeOut(duration: 1.0), value: store.tooltipState)
          .offset(y: 45)
      }
    }
    .padding(.top, 17)
    .padding(.bottom, 10)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
  
  @ViewBuilder
  private func todaysWineDescription() -> some View {
    HStack {
      VStack(alignment: .leading, spacing: 12) {
        HStack(spacing: 2) {
          Text("오늘의 와인")
            .wineyFont(.title1)
            .foregroundColor(.wineyGray50)
          
          Image(.activeWineIconW)
            .resizable()
            .frame(width: 30, height: 30)
        }
        
        Text("매일 나의 취향에 맞는 와인을 추천드려요!")
          .wineyFont(.captionM1)
          .foregroundColor(.wineyGray600)
      }
      
      Spacer()
    }
    .padding(.top, 10)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
  
  @ViewBuilder
  private func cardScrollView() -> some View {
    WineCardCarouselView(
      store: self.store.scope(
        state: \.wineCardListState,
        action: \.scrollWine
      )
    )
    .padding(.top, 20)
    .padding(.bottom, 25.5)
    .padding(.leading, 24)
  }
  
  @ViewBuilder
  private func tipView() -> some View {
    HStack(spacing: 0) {
      Group {
        Text("와인 초보를 위한 ")
        Text("TIP")
          .foregroundColor(.wineyMain2)
        Text(" !")
      }
      .wineyFont(.title2)
      
      Spacer()
      
      Image(.ic_arrow_rightW)
    }
    .foregroundColor(.wineyGray50)
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    .onTapGesture {
      store.send(.tappedTipDetailButton)
    }
    
    TipCardListView(
      store: self.store.scope(
        state: \.wineTipListState,
        action: \.wineTipList
      )
    )
    .padding(.top, 25)
  }
}

#Preview {
  MainView(
    store: .init(
      initialState: .init(),
      reducer: {
        Main()
      }
    )
  )
}

