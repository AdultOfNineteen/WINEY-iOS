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
  
  @ObservedObject var viewStore: ViewStoreOf<Login>
  @State private var didAppear = false
  
  public init(store: StoreOf<Login>) {
    self.store = store
    self.viewStore = ViewStore(self.store, observe: { $0 })
  }
  
  var body: some View {
    ZStack {
      WineyKitAsset.mainBackground.swiftUIColor.ignoresSafeArea()
      
      mainLogoSpace
      
      searchWineTextSpace
        .offset(y: -150) // mainLogoSpace로부터 위로 150
      
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
      
      Button( // 추후 삭제
        action: {
          viewStore
            .send(._gotoMain)
        },
        label: {
          Text("홈으로 이동")
        }
      )
      
      loginPathButtonSpace
        .padding(.bottom, 36)
      
      serviceInfoTextSpace
        .padding(.bottom, WineyGridRules.bottomButtonPadding)
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
    HStack(spacing: 0) {
      if let loginPath = viewStore.loginPath {
        Text("최근에 ")
        
        Text("\(loginPath.title)")
          .foregroundColor(WineyKitAsset.main3.swiftUIColor)
        
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
          viewStore.loginPath != nil ? WineyKitAsset.main3.swiftUIColor : .clear
        )
    )
  }
  
  private var serviceInfoTextSpace: some View {
    HStack(spacing: 0) {
      Text("첫 로그인 시, ")
        .foregroundColor(
          WineyKitAsset.gray700.swiftUIColor
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
  
  private var loginPathButtonSpace: some View {
    HStack(spacing: 21) {
      Button {
        print("View에서 버튼 터치 인지")
        viewStore.send(.tappedLogin(.kakao))
      } label: {
        Image("kakao_button")
      }
      
      Button {
        viewStore.send(.tappedLogin(.apple))
      } label: {
        Image("apple_button")
      }
      
      Button {
        viewStore.send(.tappedLogin(.google))
      } label: {
        Image("google_button")
      }
    }
  }
  
  private var mainLogoSpace: some View {
    VStack(spacing: 21) {
      Image("logo_imge")
        .background {
          RadientCircleBackgroundView()
            .offset(y: -15)
        }
      
      Image("logoText_imge")
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
