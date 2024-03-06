//
//  NoteDoneView.swift
//  Winey
//
//  Created by 정도현 on 12/12/23.
//  Copyright © 2023 com.winey. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

public struct NoteDoneView: View {
  
  private let store: StoreOf<NoteDone>
  @ObservedObject var viewStore: ViewStoreOf<NoteDone>
  
  public init(store: StoreOf<NoteDone>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  public var body: some View {
    ZStack {
      colorBackground()
      
      contents()
    }
    .background(
      WineyKitAsset.mainBackground.swiftUIColor
    )
    .ignoresSafeArea(edges: .bottom)
    .navigationBarHidden(true)
  }
}

extension NoteDoneView {
  
  @ViewBuilder
  private func colorBackground() -> some View {
    Image("noteDoneBackground")
      .resizable()
  }
  
  @ViewBuilder
  private func contents() -> some View {
    VStack(spacing: 0) {
      Text("테이스팅 노트 작성이\n완료 되었어요!")
        .wineyFont(.bodyB1)
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .padding(.top, 264)
        .padding(.horizontal, 49)
        .padding(.bottom, 48)
        .background(
          RoundedRectangle(cornerRadius: 7)
            .fill(
              Color(red: 63/255, green: 63/255, blue: 63/255).opacity(0.4)
            )
            .background(
              RoundedRectangle(cornerRadius: 7)
                .stroke(
                  LinearGradient(
                    colors: [
                      Color(red: 134/255, green: 124/255, blue: 162/255),
                      Color(red: 150/255, green: 113/255, blue: 1).opacity(0.5),
                      Color(red: 150/255, green: 113/255, blue: 1).opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                  ),
                  lineWidth: 1
                )
            )
        )
        .padding(.top, 136)
      
      Spacer()
      
      bottomButton()
    }
    .padding(.horizontal, WineyGridRules.globalHorizontalPadding)
  }
  
  @ViewBuilder
  private func bottomButton() -> some View {
    WineyConfirmButton(
      title: "확인",
      validBy: true,
      action: {
        viewStore.send(.tappedButton)
      }
    )
    .padding(.bottom, 54)
  }
}

#Preview {
  NoteDoneView(
    store: Store(
      initialState: NoteDone.State(),
      reducer: {
        NoteDone()
      }
    )
  )
}
