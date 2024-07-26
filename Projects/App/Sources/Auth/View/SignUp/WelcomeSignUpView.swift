//
//  WelcomeSignUpView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/21.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

struct WelcomeSignUpView: View {
  private let store: StoreOf<WelcomeSignUp>
  
  public init(
    store: StoreOf<WelcomeSignUp>
  ) {
    self.store = store
  }
  var body: some View {
    WithViewStore(
      store,
      observe: { $0 }
    ) { viewStore in
      GeometryReader {_ in
        VStack(spacing: 0) {
          
          Spacer()
            .frame(height: 68)
          
          HStack(alignment: .firstTextBaseline) {
            Text("안녕하세요\n와이니에 오신 걸 환영해요!")
              .wineyFont(.title1)
            Spacer()
          }
          .padding(
            .leading,
            WineyGridRules.globalHorizontalPadding
          )
          
          Spacer()
            .frame(height: 146)
          
          WineyAsset.Assets.welcomeWineGroup.swiftUIImage
            .resizable()
            .scaledToFit()
            .frame(width: 307.13)
            .background(
              RadientCircleBackgroundView(backgroundType: .login)
            )
          
          Spacer()
          
          WineyConfirmButton(
            title: "시작하기",
            validBy: true,
            action: {
              viewStore.send(.tappedStartButton)
            }
          )
          .padding(
            .horizontal,
            WineyGridRules.globalHorizontalPadding
          )
          .padding(.bottom, WineyGridRules.bottomButtonPadding)
        }
      }
    }
    .background(WineyKitAsset.mainBackground.swiftUIColor)
    .navigationBarHidden(true)
  }
}

struct WelcomeSignUpView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeSignUpView(
      store: StoreOf<WelcomeSignUp>(
        initialState: .init(),
        reducer: { WelcomeSignUp() }
      )
    )
  }
}
