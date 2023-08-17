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

struct AuthView: View {
  @State private var didAppear = false
  private let store: Store<AuthState, AuthAction>
  
  public init(store: Store<AuthState, AuthAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        HStack(spacing: 0) {
          Text("와인 취향")
            .foregroundColor(WineyKitAsset.gray400.swiftUIColor)
          Text("을 찾는 나만의 여정")
            .foregroundColor(WineyKitAsset.gray500.swiftUIColor)
        }
        
        Image(systemName: "shazam.logo")
        Image(systemName: "scribble.variable")
        
        VStack {
          if !viewStore.hasAuthHistory {
            HStack(spacing: 0) {
              Text("최근에 ")
              Text("\(viewStore.authPath?.rawValue ?? "")")
                .foregroundColor(WineyKitAsset.main3.swiftUIColor)
              Text("로 로그인 했어요")
            }
          }
        }
        
        HStack(spacing: 21) {
          Button {
            viewStore.send(.kakaoSignUp)
          } label: {
            Image("kakao_button")
          }
          
          Button {
            viewStore.send(.appleSignUp)
          } label: {
            Image("apple_button")
          }
          
          Button {
            viewStore.send(.gmailSingUp)
          } label: {
            Image("google_button")
          }
        }
        .foregroundColor(.white)
        
        HStack(spacing: 0) {
          Text("첫 로그인 시, ")
          Button("서비스 이용약관") {
            
          }
          Text("에 동의한 것으로 간주합니다")
        }
        .wineyFont(.captionM1)
      }
      .onAppear {
        guard !didAppear else { return }
        viewStore.send(._onAppear)
        didAppear = true
      }
    }
    .navigationBarHidden(true)
  }
}

struct AuthView_Previews: PreviewProvider {
  static var previews: some View {
    AuthView(
      store: Store<AuthState, AuthAction>(
        initialState: .init(),
        reducer: setAuthReducer,
        environment: SetAuthEnvironment(
          mainQueue: .main,
          userDefaultsService: .live)
      )
    )
  }
}
