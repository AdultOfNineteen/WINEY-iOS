//
//  SetCategoryView.swift
//  Winey
//
//  Created by 박혜운 on 2023/08/10.
//  Copyright © 2023 com.adultOfNineteen. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import WineyKit

struct LoginView: View {
  @State private var didAppear = false
  private let store: Store<LoginState, LoginAction>
  
  public init(store: Store<LoginState, LoginAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      GeometryReader {_ in
        ZStack(alignment: .center) {
          mainLogoSpace
          
          searchWineTextSpace
          .offset(y: -150) // mainLogoSpace로부터 위로 150
          
          bottomSpace // 로그인 경로 Text부터 서비스 이용약관까지
          .offset(y: -20) // 화면 최 하단으로부터 위로 20
        }
        .onAppear {
          guard !didAppear else { return }
          viewStore.send(._onAppear)
          didAppear = true
        }
      }
    }
  }
  
  private var bottomSpace: some View {
    WithViewStore(store) { viewStore in
      VStack { // 로그인 경로 Text부터 서비스 이용약관까지
        Spacer()
        VStack(spacing: 0) {
          if !viewStore.hasLoginHistory {
            loginPathTextSpace
          }
        }
        .padding(.bottom, 30)
        
        loginPathButtonSpace
          .padding(.bottom, 36)
        
        serviceInfoTextSpace
      }
    }
  }
  
  private var searchWineTextSpace: some View {
    HStack(spacing: 0) {
      Text("와인 취향")
        .foregroundColor(WineyKitAsset.gray400.swiftUIColor)
      
      Text("을 찾는 나만의 여정")
        .foregroundColor(WineyKitAsset.gray500.swiftUIColor)
    }
    .wineyFont(.bodyM1)
  }
  
  private var loginPathTextSpace: some View {
    WithViewStore(store) { viewStore in
      HStack(spacing: 0) {
        Text("최근에 ")
        
        Text("\(viewStore.loginPath?.rawValue ?? "")")
        .foregroundColor(WineyKitAsset.main3.swiftUIColor)
        
        Text("로 로그인 했어요")
      }
      .padding(.vertical, 7)
      .padding(.horizontal, 15)
      .wineyFont(.captionM1)
      .background(
        RoundedRectangle(cornerRadius: 38)  // 라운드의 각도 설정
        .stroke(style: StrokeStyle(lineWidth: 1, dash: [2, 2])) // 점선 스타일 설정
        .foregroundColor(
          WineyKitAsset.main3.swiftUIColor
        )
      )
    }
  }
  
  private var serviceInfoTextSpace: some View {
    WithViewStore(store) { viewStore in
      HStack(spacing: 0) {
        Text("첫 로그인 시, ")
          .foregroundColor(
            WineyKitAsset.gray700.swiftUIColor
          )
        Button(
          action: {
            viewStore
              .send(.tappedTermsOfUse)
          },
          label: {
            Text("서비스 이용약관")
              .background{
                Rectangle()
                  .frame(height: 1)
                  .offset(y: 7)
              }
              .foregroundColor(
                WineyKitAsset
                  .gray50
                  .swiftUIColor
              )
          }
        )
        Text("에 동의한 것으로 간주합니다")
          .foregroundColor(
            WineyKitAsset
              .gray700
              .swiftUIColor
          )
      }
      .wineyFont(.captionM1)
    }
  }
  
  private var loginPathButtonSpace: some View {
    WithViewStore(store) { viewStore in
      HStack(spacing: 21) {
        Button {
          viewStore.send(.tappedLoginPath(.kakao))
        } label: {
          Image("kakao_button")
        }
        
        Button {
          viewStore.send(.tappedLoginPath(.apple))
        } label: {
          Image("apple_button")
        }
        
        Button {
          viewStore.send(.tappedLoginPath(.gmail))
        } label: {
          Image("google_button")
        }
      }
    }
  }
  
  private var mainLogoSpace: some View {
    VStack(spacing: 21) {
      Image("logo_imge")
        .background {
          RadientCircleBackgroundView()
        }
      
      ZStack(alignment: .top) {
        Image("logoText_imge")
        Image("wave_imge")
          .offset(y: 2)
      }
    }
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView(
      store: Store<LoginState, LoginAction>(
        initialState: .init(),
        reducer: setLoginReducer,
        environment: SetLoginEnvironment(
          mainQueue: .main,
          userDefaultsService: .live)
      )
    )
  }
}
