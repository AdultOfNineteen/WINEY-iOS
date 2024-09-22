//
//  WineAnalysisView.swift
//  Winey
//
//  Created by 정도현 on 2023/09/14.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct WineAnalysisView: View {
  private let store: StoreOf<WineAnalysis>
  
  public init(store: StoreOf<WineAnalysis>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      navigation()
      
      content()
    }
    .bottomSheet(
      backgroundColor: Color.wineyGray950,
      isPresented: .init(
        get: { store.isPresentedBottomSheet },
        set: { _ in
          store.send(.tappedOutsideOfBottomSheet)
        }
      ),
      headerArea: {
        Image(.analysisNoteIconW)
      },
      content: {
        CustomVStack(
          text1: "재구매 의사가 담긴",
          text2: "테이스팅 노트가 있는 경우에 볼 수 있어요!"
        )
        .popGestureDisabled()
      },
      bottomArea: {
        HStack {
          WineyConfirmButton(
            title: "확인",
            validBy: true,
            action: {
              store.send(.tappedConfirmButton)
            }
          )
        }
        .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
      }
    )
    .onChange(of: store.state.isPresentedBottomSheet) { sheetAppear in
      if sheetAppear {
        UIApplication.shared.endEditing()
      }
    }
    .onAppear {
      store.send(._onAppear)
    }
    .background(.wineyMainBackground)
    .navigationBarHidden(true)
  }
}

extension WineAnalysisView {
  
  @ViewBuilder
  private func navigation() -> some View {
    NavigationBar(
      leftIcon: Image(.navigationBack_buttonW),
      leftIconButtonAction: {
        store.send(.tappedBackButton)
      },
      backgroundColor: .wineyMainBackground
    )
  }
  
  @ViewBuilder
  private func content() -> some View {
    ZStack(alignment: .center) {
      Image(.analysisBackgroundW)
        .resizable()
        .padding(.top, 34)
      
      VStack(spacing: 0) {
        analysisTitle()
        
        Spacer()
        
        analysisButton()
      }
      .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
    }
    .padding(.top, 20)
  }
  
  @ViewBuilder
  private func analysisTitle() -> some View {
    HStack {
      Text("나의")
        .foregroundColor(.wineyGray50)
      Text("와인 취향")
        .foregroundColor(.wineyMain3)
      Text("분석")
        .foregroundColor(.wineyGray50)
      
      Spacer()
    }
    .wineyFont(.title1)
    
    HStack {
      Text("작성한 테이스팅 노트를 기반으로 나의 와인 취향을 분석해요!")
        .foregroundColor(.wineyGray700)
        .wineyFont(.captionB1)
      
      Spacer()
    }
    .padding(.top, 18)
  }
  
  @ViewBuilder
  private func analysisButton() -> some View {
    Button {
      store.send(.tappedAnalysis)
    } label: {
      Text("분석하기")
        .wineyFont(.bodyB2)
        .foregroundColor(.white)
        .padding(.horizontal, 73)
        .padding(.vertical, 16)
        .background {
          RoundedRectangle(cornerRadius: 46)
            .fill(.wineyMain1)
            .shadow(color: .wineyMain1, radius: 8)
        }
    }
    .padding(.bottom, 84)
  }
}

public struct WineAnalysisView_Previews: PreviewProvider {
  public static var previews: some View {
    WineAnalysisView(
      store: Store(
        initialState: WineAnalysis.State.init(isPresentedBottomSheet: false),
        reducer: {
          WineAnalysis()
        }
      )
    )
  }
}
