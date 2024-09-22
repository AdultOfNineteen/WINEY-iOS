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
  private let store: StoreOf<Login>

  @State private var didAppear = false
  
  public init(store: StoreOf<Login>) {
    self.store = store
  }
  
  var body: some View {
    ZStack {
      Color.wineyMainBackground.ignoresSafeArea()
      
      centerSpace
   
      bottomSpace // 로그인 경로 Text부터 서비스 이용약관까지
        .offset(y: -20) // 화면 최 하단으로부터 위로 20
    }
    .onAppear {
      guard !didAppear else { return }
      store.send(._onAppear)
      didAppear = true
    }
  }
  
  private var bottomSpace: some View {
    VStack { // 로그인 경로 Text부터 서비스 이용약관까지
      Spacer()
      
      VStack(spacing: 0) {
        loginPathTextSpace
      }
      .padding(.bottom, 30)

      loginPathButtonSpace
        .padding(.bottom, 36)
      
      serviceInfoTextSpace
        .padding(.bottom, WineyGridRules.bottomButtonPadding)
    }
  }
  
  private var centerSpace: some View {
    VStack(spacing: 42) {
      Spacer()
        .frame(maxHeight: 200)
      
      searchWineTextSpace
      
      mainLogoSpace
      
      Spacer()
    }
    .background {
      RadientCircleBackgroundView(backgroundType: .login)
        .offset(y: -30)
    }
  }
  
  private var searchWineTextSpace: some View {
    HStack(spacing: 0) {
      Text("와인 취향")
        .foregroundColor(.wineyGray400)
      
      Text("을 찾는 나만의 여정")
        .foregroundColor(.wineyGray500)
    }
    .wineyFont(.bodyM1)
  }
  
  private var loginPathTextSpace: some View {
    HStack(spacing: 0) {
      if let loginPath = store.loginPath {
        Text("최근에 ")
        
        Text("\(loginPath.title)")
          .foregroundColor(.wineyMain3)
        
        Text("로 로그인 했어요")
      }
    }
    .padding(.vertical, 7)
    .padding(.horizontal, 15)
    .wineyFont(.captionM1)
    .background(
      RoundedRectangle(cornerRadius: 38)  // 라운드의 각도 설정
        .stroke(style: StrokeStyle(lineWidth: 1, dash: [2, 2])) // 점선 스타일 설정
        .foregroundColor(
          store.loginPath != nil ? .wineyMain3 : .clear
        )
    )
  }
  
  private var serviceInfoTextSpace: some View {
    HStack(spacing: 0) {
      Text("첫 로그인 시, ")
        .foregroundColor(
          .wineyGray700
        )
      Button(
        action: {
          UIApplication.shared.open(
            URL(string: "http://winey-api-dev-env.eba-atefsiev.ap-northeast-2.elasticbeanstalk.com/docs/service-policy.html")!
          )
        },
        label: {
          Text("서비스 이용약관")
            .background{
              Rectangle()
                .frame(height: 1)
                .offset(y: 7)
            }
            .foregroundColor(.wineyGray50)
        }
      )
      Text("에 동의한 것으로 간주합니다")
        .foregroundColor(.wineyGray700)
    }
    .wineyFont(.captionM1)
  }
  
  private var loginPathButtonSpace: some View {
    HStack(spacing: 21) {
      Button {
        store.send(.tappedLogin(.kakao))
      } label: {
        Image(.kakao_buttonW)
      }
      
      Button {
        store.send(.tappedLogin(.apple))
      } label: {
        Image(.apple_buttonW)
      }
      
      Button {
        store.send(.tappedLogin(.google))
      } label: {
        Image(.google_buttonW)
      }
    }
  }
  
  private var mainLogoSpace: some View {
    VStack(spacing: 24) {
      Image(.logo_imgeW)
      
      Image(.logoText_imgeW)
    }
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView(
      store: StoreOf<Login>(
        initialState: .init(),
        reducer: { Login() }
      )
    )
  }
}
