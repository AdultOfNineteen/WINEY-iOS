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
          if true {
            HStack(
              alignment: .firstTextBaseline
            ) {
              Text("이제 와인을\n마시러 가보실까요?")
                .wineyFont(.title1)
              Spacer()
            }
            .padding(
              .leading,
              WineyGridRules.globalHorizontalPadding
            )
            
            Spacer()
              .frame(height: 57)
            
            ZStack {
              RoundedRectangle(cornerRadius: 7)
                .foregroundStyle(.ultraThinMaterial)
              
              RoundedRectangle(cornerRadius: 7)
                .stroke(
                  WineyKitAsset.line1.swiftUIColor.opacity(0.2),
                  lineWidth: 1.0
                )
              
              RoundedRectangle(cornerRadius: 7)
                .strokeBorder(
                  LinearGradient(
                    colors: [
                      .white.opacity(0.5),
                      WineyKitAsset.line1.swiftUIColor.opacity(0.6),
                      WineyKitAsset.line1.swiftUIColor
                        .opacity(0.2)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                  ),
                  lineWidth: 1
                )
              VStack(spacing: 0) {
                if viewStore.showcaseType == .sour {
                  WineyAsset.Assets.showcaseSourWine.swiftUIImage } else {
                    WineyAsset.Assets.showcaseScentWine.swiftUIImage
                  }
                
                Spacer()
                  .frame(height: 12)
                
                Text(viewStore.showcaseType == .sour ? "레드 와인" : "화이트 와인")
                  .wineyFont(.captionM1)
                  .foregroundColor(.white)
                  .padding(.horizontal, 10)
                  .padding(.vertical, 3)
                  .background {
                    RoundedRectangle(cornerRadius: 48)
                      .fill(WineyKitAsset.main1.swiftUIColor)
                  }
                
                Spacer()
                  .frame(height: 17)
                
                Text(viewStore.showcaseType == .sour ? "산미의 중요성을 아는 와이너" : "향을 즐길 줄 아는 와이너")
                  .wineyFont(.bodyM1)
                  .foregroundColor(.white)
                
                Spacer()
                  .frame(height: 9)
                
                Text("담당자에게 해당 화면을 보여주세요!")
                  .wineyFont(.captionM1)
                  .foregroundColor(WineyKitAsset.gray700.swiftUIColor)
              }
            }
            .frame(width: 242)
            .frame(height: 347)
            .background(
              RadientCircleBackgroundView(backgroundType: .login)
            )
            
          } else {
            HStack(alignment: .firstTextBaseline) {
              Text("안녕하세요\n와이니에 오신 걸 환영해요!")
                .wineyFont(.title1)
              Spacer()
            }
            .padding(
              .leading,
              WineyGridRules.globalHorizontalPadding
            )
          }
          
          Spacer()
          
          WineyConfirmButton(
            title: "와이니 시작하기", // 큐시즘, default: "시작하기"
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
        initialState: .init(showcaseType: .sour),
        reducer: { WelcomeSignUp() }
      )
    )
  }
}
