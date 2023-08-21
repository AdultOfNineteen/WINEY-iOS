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
            if !viewStore.hasLoginHistory {
              HStack(spacing: 0) {
                Text("최근에 ")
                
                Text("\(viewStore.loginPath?.rawValue ?? "")")
                  .foregroundColor(WineyKitAsset.main3.swiftUIColor)
                
                Text("로 로그인 했어요")
                
              }
            }
          }
          
          HStack(spacing: 21) {
            
            Spacer()
            
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
            
            Spacer()
            
          }
          .foregroundColor(.white)
          
          HStack(spacing: 0) {
            Text("첫 로그인 시, ")
            
            Button("서비스 이용약관") {
              viewStore.send(.tappedTermsOfUse)
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
